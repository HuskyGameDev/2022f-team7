extends Area2D

var interacting = false;
enum type {popup, dialog, cutscene, button}
export (type) var mode = type.popup

export var dialog:String = "placeholder!"

signal interacted

func _ready():
	$CanvasInteractions/popup.hide()
	$CanvasInteractions/dialog.hide()
	$CanvasInteractions/hint.hide()

func _on_body_entered(body):
	print("interact in range of " + body.get_name())
	if(body.is_in_group("player")):
		interacting = true
		$CanvasInteractions/hint.show()
		if mode == type.cutscene:
			cutscene()

func _on_body_exited(body):
	print("interact not in range of " + body.get_name())
	if(body.is_in_group("player")):
		interacting = false
		$CanvasInteractions/hint.hide()
		$CanvasInteractions/popup.hide()
		
func _input(event):
	if event.is_action_pressed("interact"):
		match(mode):
			type.popup:
				popup()
			type.dialog:
				dialog()
			type.button:
				button()

func popup(): #TODO: clean this up
	if interacting == false:
		print("player not interacting")
		return
	if get_tree().paused == true && $CanvasInteractions.visible == false:
		print("other process in progress")
		return
	
	if get_tree().paused == false:
		get_tree().paused = true
		$CanvasInteractions/popup.show()
		print("player is interacting")
	else:
		get_tree().paused = false
		$CanvasInteractions/popup.hide()
		print("player stopped interacting")

func dialog():
	pass #unfinished

func cutscene():
	pass #unfinished

func button():
	print("activated!")
	#types that use this mode will extend this function to do whatever non blocking things needs to happen

func _on_option1_pressed():
	pass

func _on_option2_pressed():
	pass
