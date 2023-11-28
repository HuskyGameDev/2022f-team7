extends Node2D

var SwitchOn = false
var inRange = false

signal switchActivated(check)

func _ready():
	$AnimatedSprite.frame = SwitchOn

func _input(event):
	if(event.is_action_pressed("interact") && inRange):
		$AnimatedSprite.frame = !SwitchOn
		SwitchOn = !SwitchOn
		emit_signal("switchActivated",SwitchOn)
		if SwitchOn:
			$AudioStreamPlayer.pitch_scale = 1
		else:
			$AudioStreamPlayer.pitch_scale = 0.6
		$AudioStreamPlayer.play()

func _on_Area2D_area_entered(_area):
	inRange = true
	$CanvasInteractions.visible = true


func _on_Area2D_body_exited(_body):
	inRange = false
	$CanvasInteractions.visible = false
