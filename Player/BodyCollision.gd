extends Area2D

var colliding = false

func _on_BodyCollision_body_entered(_body):
	colliding = true

func _on_BodyCollision_body_exited(_body):
	colliding = false
