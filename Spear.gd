extends RigidBody2D


# Declare member variables here
export var speed = 500
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
	initSpear = false
	direction = Vector2(mouseCoords.x, mouseCoords.y)
	angle = direction.angle()
	print(rad2deg(angle))
	
	rotation = angle
	position = playerPos
	linear_velocity = direction.normalized() * speed
	if rad2deg(angle) < -90:
		print("left")
		angular_velocity = -1
	if rad2deg(angle) > -90:
		print("right")
		angular_velocity = 1
	show()
