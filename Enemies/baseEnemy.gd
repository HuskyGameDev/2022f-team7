extends KinematicBody2D

#0, follow, 1, use path, 2, follow with nav agent
export var mode:int = 0
export var speed:int = 1
var engaged = false #for 0 and 2
var vec = Vector2.ZERO
var player:KinematicBody2D
var hp: int = 1

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
		1:#MUST be a child of a pathfollower!
			self.get_parent().unit_offset += (.0005 * speed)
		2:
			pass

func _ready():
	if self.get_parent() is PathFollow2D: 
		#automatically become path follower if it is a child of a path
		mode = 1

#control if the enemy should be engaged with the player
func _onStartEnter(body):
	player = body
	engaged = true
func _onStopExit(body):
	engaged = false


func _on_hitbox_area_entered(area):
	if(area.is_in_group('spear')):
		hp = hp - 1
		if (hp<=0):
			queue_free()
