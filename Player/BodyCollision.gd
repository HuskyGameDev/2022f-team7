extends Area2D

var colliding = false

func _on_BodyCollision_body_entered(body):
	print("body touched! " + body.name)
	colliding = true

func _on_BodyCollision_body_exited(_body):
	colliding = false
