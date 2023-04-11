extends Node2D


export var startEnabled = true
export(float, 10) var speed = 0.5
export(int, 10) var delay = 1

var start = Vector2(0,0)

var atEnd = false

#must be a kinematic body for the player to stick to the platform when moving!!!

func _ready():
	$Timer.wait_time = delay
	if startEnabled:
		movePlat()

#once moved up, start delay
func _on_Tween_tween_completed(object, key):
	$Timer.start()

func _on_Timer_timeout():
	movePlat()

func movePlat():
	if !atEnd: $Tween.interpolate_property($platform, "position", start, $target.position, 1/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	else:      $Tween.interpolate_property($platform, "position", $target.position, start, 1/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	atEnd = !atEnd

func _on_KeyPlatform_ActivatedMovingPlatforms():
	if !startEnabled: movePlat()
