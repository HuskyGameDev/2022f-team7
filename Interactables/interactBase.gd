extends Area2D

var inRange = false
var interacting = false
var dialogTest = false
var amountVis : float = 0
enum type {popup, dialog, cutscene, button}

export var textSpeed = 30
export (type) var mode = type.popup
export var pauseTree = false
export var dialog:String = "placeholder!"

onready var dialogBox = $CanvasInteractions/dialog/VBoxContainer/HBoxContainer/dialogBox
onready var pauseScreen = get_node("/root/levelRoot/pauseScreen")

signal interacted #unused

func _ready():
	$CanvasInteractions/popup.hide()
	$CanvasInteractions/dialog.hide()
	$CanvasInteractions/hint.hide()

func _on_body_entered(body):
	print("interact in range of " + body.get_name())
	if(body.is_in_group("player")):
		inRange = true
		$CanvasInteractions/hint.show()
		if mode == type.cutscene:
			cutscene()

func _on_body_exited(body):
	print("interact not in range of " + body.get_name())
	if(body.is_in_group("player")):
		inRange = false
		$CanvasInteractions/hint.hide()
		$CanvasInteractions/popup.hide()
		

#note that all modes are responsible for the interact state
func _input(event):
	if event.is_action_pressed("interact") && inRange:
		
		if pauseScreen.visible:
			print("other process in progress")
			return
		
		if pauseTree:
			get_tree().paused = true
		
		match(mode):
			type.popup:
				popup()
			type.dialog:
				dialog()
			type.button:
				button()

func popup():
	interacting = !interacting
	$CanvasInteractions/popup.visible = interacting
	get_tree().paused = interacting && pauseTree
	
#	if get_tree().paused == true && $CanvasInteractions.visible == false:
#		print("other process in progress")
#		return

func dialog():
	dialogTest = !dialogTest
	interacting = !interacting
	$CanvasInteractions/dialog.visible = interacting
	get_tree().paused = interacting && pauseTree
	dialogBox.get_v_scroll().value = 0
	amountVis = 0
	print(dialogBox.get_total_character_count())

func _process(delta):
	if dialogTest && dialogBox.get_total_character_count() != dialogBox.visible_characters:
		amountVis += (textSpeed * delta)
		dialogBox.visible_characters = amountVis
		
		if dialogBox.get_visible_line_count() > 5:
			dialogBox.get_v_scroll().value += 3

func cutscene():
	pass #unfinished

func button():
	print("activated!")
	

func _on_option1_pressed():
	pass

func _on_option2_pressed():
	pass
