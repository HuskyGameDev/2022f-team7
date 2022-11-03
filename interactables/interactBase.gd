extends Area2D

var interacting = false;
var player;

signal interacted;

func _ready():
	$CanvasPrompt.hide()
	$CanvasInteractions.hide()
	pass

func _on_body_entered(body):
	print("fingers touching " + body.get_name())
	if(body.is_in_group("player")):
		player = body
		interacting = true
		$CanvasPrompt.show()
		
func _on_body_exited(body):
	print("fingers stopped touching " + body.get_name())
	if(body.is_in_group("player")):
		player = null
		interacting = false
		$CanvasPrompt.hide()
		$CanvasInteractions.hide()
		
func _input(event):
	if event.is_action_pressed("interact"): #prevent spam in terminal
		if interacting == false:
			print("player not interacting")
			return
		if get_tree().paused == false:
			get_tree().paused = true
			$CanvasInteractions.show()
			print("player is interacting")
		else:
			get_tree().paused = false
			$CanvasInteractions.hide()
			print("player stopped interacting")
			
