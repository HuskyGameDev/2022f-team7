extends Node2D

enum tweens {TRANS_LINEAR, TRANS_SINE, TRANS_QUINT, TRANS_QUART, TRANS_QUAD, TRANS_EXPO, TRANS_ELASTIC, TRANS_CUBIC, TRANS_CIRC, TRANS_BOUNCE, TRANS_BACK}
enum eases {EASE_IN, EASE_OUT, EASE_IN_OUT, EASE_OUT_IN}
var isOut = false

export(tweens) var type = Tween.TRANS_CUBIC
export(eases) var easing = Tween.EASE_IN_OUT
export(float) var speed = 1.0

var start = Vector2(0,-80)
var end = Vector2(0,40)

func _ready():
	$Tween.interpolate_property($Sprite, "position", start, end, speed, type, easing)
	$Tween.start()


func _on_Tween_tween_completed(object, key):
	isOut = !isOut
	
	if isOut:
		$Tween.interpolate_property($Sprite, "position", end, start, speed, type, easing)
	else:
		$Tween.interpolate_property($Sprite, "position", start, end, speed, type, easing)
	
	$Tween.start()
