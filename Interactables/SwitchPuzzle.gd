extends Node2D

var SwitchOn = false
var inRange = false

signal switchActivated(check)

func _ready():
	$Sprite.modulate = Color.red

func _input(event):
	if(event.is_action_pressed("interact") && inRange):
		$Sprite.modulate = Color.green if !SwitchOn else Color.red
		SwitchOn = !SwitchOn
		emit_signal("switchActivated",SwitchOn)

func _on_Area2D_area_entered(area):
	if(area.is_in_group("player")):
		inRange = true
