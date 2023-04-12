extends Node2D

enum tweens {TRANS_LINEAR, TRANS_SINE, TRANS_QUINT, TRANS_QUART, TRANS_QUAD, TRANS_EXPO, TRANS_ELASTIC, TRANS_CUBIC, TRANS_CIRC, TRANS_BOUNCE, TRANS_BACK}
enum eases {EASE_IN, EASE_OUT, EASE_IN_OUT, EASE_OUT_IN}

export var startEnabled = true
export(float, 10) var speed = 0.5
export(int, 10) var delay = 1
export(tweens) var type = Tween.TRANS_SINE
export(eases) var easing = Tween.EASE_IN_OUT

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
	if !atEnd: $Tween.interpolate_property($platform, "position", start, $target.position, 1/speed, type, easing)
	else:      $Tween.interpolate_property($platform, "position", $target.position, start, 1/speed, type, easing)
	$Tween.start()
	atEnd = !atEnd

func _on_KeyPlatform_ActivatedMovingPlatforms():
	if !startEnabled: movePlat()
