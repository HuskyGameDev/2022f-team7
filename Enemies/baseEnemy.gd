extends KinematicBody2D

#0, follow, 1, use path, 2, ground based movement, 3 for custom/no default behavior
export var mode:int = 0
export var speed:float = 1
var engaged = false #for 0 and 2
var vec = Vector2.ZERO
var player:KinematicBody2D
var hp: int = 1

func _physics_process(delta):
	match(mode):
		0:
			if engaged:
				vec = (position - player.position).normalized()
				vec *= -0.2
				move_and_collide(vec, false)
		1:#MUST be a child of a pathfollower!
			self.get_parent().unit_offset += (.0005 * speed)
		2:
			pass #have not finished yet, no enemies use it either
		3:
			customMode()
	
	custom()

#called per physics frame after mode code
func custom():
	pass
	#method for inherriting enemies to override for custom functionality in addition to the modes

#called per physics frame if enemy is of mode 3
func customMode():
	pass
	#method for handling a custom mode in new enemies

func _ready():
	if self.get_parent() is PathFollow2D: 
		#automatically become path follower if it is a child of a path
		mode = 1

#control if the enemy should be engaged with the player
func _onStartEnter(body):
	print("body touched! " + body.name)
	#if body is in group("player"):
	player = body
	engaged = true

func _onStopExit(body):
	engaged = false

func _on_hitbox_area_entered(area):
	print("enemy touched! " + area.name)
	if(area.is_in_group('spear')):
		hp -= 1
		if (hp<=0):
			queue_free()
