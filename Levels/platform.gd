extends KinematicBody2D




func _ready():
	$AnimationPlayer.stop(false)

func _on_KeyPlatform_ActivatedMovingPlatforms():
	$AnimationPlayer.play("platform")
