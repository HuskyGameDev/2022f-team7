extends RigidBody2D


# Declare member variables here
export var speed = 500
var angle
var initSpear
var direction
var playerPos




#TODO: pixel perfect movement, sprites instead of rotation to fit art style

func start(mouseCoords, pos):
	hide()
	playerPos = pos
	initSpear = false
	direction = Vector2(mouseCoords.x, mouseCoords.y)
	angle = direction.angle()
	
	rotation = angle
	position = playerPos
	linear_velocity = direction.normalized() * speed
	if rad2deg(angle) < -90:
		angular_velocity = -1
	if rad2deg(angle) > -90:
		angular_velocity = 1
	show()
