extends Area2D

var interacting = false;

signal interacted;

func _ready():
	$CanvasPrompt.hide()
	$CanvasInteractions.hide()
	

func _on_body_entered(body):
	print("fingers touching " + body.get_name())
	if(body.is_in_group("player")):
		interacting = true
		$CanvasPrompt.show()
		
func _on_body_exited(body):
	print("fingers stopped touching " + body.get_name())
	if(body.is_in_group("player")):
		interacting = false
		$CanvasPrompt.hide()
		$CanvasInteractions.hide()
		
func _input(event):
	if event.is_action_pressed("interact"): #prevent spam in terminal
		if interacting == false:
			print("player not interacting")
			return
		if get_tree().paused == true && $CanvasInteractions.visible == false:
			print("other process in progress")
			return
		
		if get_tree().paused == false:
			get_tree().paused = true
			$CanvasInteractions.show()
			$CanvasPrompt.hide()
			print("player is interacting")
		else:
			get_tree().paused = false
			$CanvasInteractions.hide()
			$CanvasPrompt.show()
			print("player stopped interacting")
			
