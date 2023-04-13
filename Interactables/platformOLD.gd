extends KinematicBody2D

export var startEnabled = true

func _ready():
	if startEnabled: 
		$AnimationPlayer.play("platform")
