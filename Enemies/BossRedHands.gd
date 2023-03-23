extends "res://Enemies/baseEnemy.gd"

func _physics_process(delta):
	match(mode):
		modes.follow:
			if engaged:
				vec = (position - player.position).normalized()
				vec *= -0.2
				move_and_collide(vec, false)
			else:
				#will change later to better suit the hands being within range of boss
				if (position - get_parent().position < 1):
					vec = (position - get_parent().position).normalized()
					vec *= -0.2
					move_and_collide(vec, false)
		modes.rails:#MUST be a child of a pathfollower!
			self.get_parent().unit_offset += (.0005 * railSpeed)
		modes.walker:
			pass #have not finished yet, no enemies use it either
		modes.custom:
			customMode(delta)
			

func custom(_delta):
	$AnimatedSprite.frame = engaged

func customMode(_delta): 
	pass


