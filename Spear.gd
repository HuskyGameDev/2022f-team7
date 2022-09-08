extends RigidBody2D


# Declare member variables here
var speed
var angle
var initSpear
var direction
var playerPos




# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func start(mouseCoords, pos):
	hide()
	playerPos = pos
	initSpear = true
	speed = 500
	direction = Vector2(mouseCoords.x, mouseCoords.y)
	angle = direction.angle()
	print(rad2deg(angle))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!is_visible() && self.rotation_degrees != 0):
		show()
	pass

func _integrate_forces(state):
	if(initSpear):
		initSpear = false
		var xform = state.get_transform()
		xform = xform.rotated(angle)
		xform.origin = playerPos
		state.set_transform(xform)
		state.linear_velocity = direction.normalized() * speed
