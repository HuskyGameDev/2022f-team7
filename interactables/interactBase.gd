extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	pass
	#$CanvasPrompt.hide()
	#$CanvasInteractions.hide()



func _on_body_entered(body):
	print("fingers touching " + body.get_name())
	if(body.is_in_group("player")):
		$CanvasPrompt.show()
		
func _on_body_exited(body):
	print("fingers stopped touching " + body.get_name())
	if(body.is_in_group("player")):
		$CanvasPrompt.hide()
		$CanvasInteractions.hide()
