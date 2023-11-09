extends KinematicBody2D

var target = Vector2(-5,-96)
var start = Vector2(-5, -48)

var ons:int = 0

func _on_SwitchPuzzle_switchActivated(check):
	if(check):
		ons += 1
	else:
		ons -= 1
	
	if ons > 0:
		setTween($StaticBody2D/NinePatchRect.rect_position, target)
		$StaticBody2D.set_collision_layer_bit(0, false)
	else:
		setTween($StaticBody2D/NinePatchRect.rect_position, start)
		$StaticBody2D.set_collision_layer_bit(0, true)
	
	$Tween.start()
	

#this doesn't *really* need to be a separate func but it's a really long command and makes it easier to adjust properties
func setTween(startp, endp):
	$Tween.interpolate_property($StaticBody2D/NinePatchRect, "rect_position", startp, endp, 1, Tween.TRANS_QUAD, Tween.EASE_IN)
