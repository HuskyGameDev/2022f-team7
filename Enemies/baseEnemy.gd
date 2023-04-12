extends KinematicBody2D

#0, follow, 1, use path, 2, ground based movement, 3 for custom/no default behavior
enum modes {follow, rails, walker, custom}
export (modes) var mode = modes.follow
export var railSpeed:float = 1
var engaged = false #for 0 and 2
var vec = Vector2.ZERO
var player:KinematicBody2D
var hp: int = 1

func _physics_process(delta):
	match(mode):
		modes.follow:
			if engaged:
				vec = (position - player.position).normalized()
				vec *= -0.2
				move_and_collide(vec, false)
		modes.rails:#MUST be a child of a pathfollower!
			self.get_parent().unit_offset += (.0005 * railSpeed)
		modes.walker:
			pass #have not finished yet, no enemies use it either
		modes.custom:
			customMode(delta)
	
	custom(delta)

#called per physics frame after mode code
func custom(delta):
	pass
	#method for inherriting enemies to override for custom functionality in addition to the modes

#called per physics frame if enemy is of mode 3
func customMode(delta):
	pass
	#method for handling a custom mode in new enemies

func _ready():
	if self.get_parent() is PathFollow2D: 
		#automatically become path follower if it is a child of a path
		mode = 1

#control if the enemy should be engaged with the player
func _onStartEnter(body):
	#if body is in group("player"):
	if(body.get_class() == "KinematicBody2D"):
		player = body
	engaged = true

func _onStopExit(body):
	engaged = false

func _on_hitbox_area_entered(area):
	if(area.is_in_group('spear')):
		hp -= 1
		if (hp<=0):
			
			queue_free()
