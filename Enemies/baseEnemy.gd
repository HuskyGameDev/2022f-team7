extends KinematicBody2D

#0, follow, 1, use path, 2, follow with nav agent
var mode = 0
var engaged = false #for 0 and 2
var vec = Vector2.ZERO
var player:KinematicBody2D

func _physics_process(delta):
	match(mode):
		0:
			if engaged:
				$AnimatedSprite.frame = 1
				vec = (position - player.position).normalized()
				vec *= -0.2
				move_and_collide(vec, false)
			else:
				$AnimatedSprite.frame = 0
		1:
			pass
		2:
			pass



#control if the enemy should be engaged with the player
func _onStartEnter(body):
	player = body
	engaged = true
func _onStopExit(body):
	engaged = false
