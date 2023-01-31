extends Area2D

var inRange = false
var interacting = false
enum type {popup, dialog, cutscene, button}
export (type) var mode = type.popup

export var dialog:String = "placeholder!"

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
		
func _input(event):
	if event.is_action_pressed("interact") && inRange:
		print(get_tree().paused)
		interacting = true
		
		if get_tree().paused:
			print("other process in progress")
			return
		
		match(mode):
			type.popup:
				popup()
			type.dialog:
				dialog()
			type.button:
				button()

func popup():
	$CanvasInteractions/popup.visible = !$CanvasInteractions/popup.visible
	interacting = $CanvasInteractions/popup.visible
#	if get_tree().paused == true && $CanvasInteractions.visible == false:
#		print("other process in progress")
#		return

func dialog():
	pass #unfinished

func cutscene():
	pass #unfinished

func button():
	print("activated!")
	

func _on_option1_pressed():
	pass

func _on_option2_pressed():
	pass
