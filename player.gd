extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var vec = Vector2.ZERO

func _physics_process(delta):
	
	if !is_on_floor():
		vec.y += delta * 400 
		#gravity, only this accounts for frame time differences since move/slide already accounts for this somewhat, but gravity is additive
	else:
		vec.y = 1
	
	
	vec.x = 0
	
	if Input.is_action_just_pressed("dash"):
		pass #no dash implemented
	if Input.is_action_pressed("moveDown"):
		pass #for slam or crouch if needed
	if Input.is_action_just_pressed("jump") && is_on_floor():
		vec.y = -400
	if Input.is_action_pressed("moveLeft"):
		vec.x += -175
	if Input.is_action_pressed("moveRight"):
		vec.x += 175
	
	print(is_on_floor())
	
	move_and_slide(vec, Vector2.UP, true, 4, deg2rad(45), true)


func _process(delta):
	pass

