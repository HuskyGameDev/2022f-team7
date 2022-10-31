extends Area2D

var interacting = false;
var player;

func processInput():
	
	if !interacting:
		print(interacting)
		return
	
	if Input.is_action_just_pressed("interact"):
		print(interacting);
		print("player is interacting");

func _ready():
	#$CanvasPrompt.hide()
	#$CanvasInteractions.hide()
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
