extends RigidBody2D


# Declare member variables here
export var speed = 200
export var stick_angle = 40 # angle within which the spear will stick to walls
export var error = 0.05 # The error when checking if velocity is zero
var angle
var initSpear
var direction
var playerPos
var stuck = false
var mouseIn = false

signal spear_collected




#TODO: pixel perfect movement, sprites instead of rotation to fit art style

func start(mouseCoords, pos):
	hide() # Hide the spear while it is being positioned
	playerPos = pos
	initSpear = false
	direction = Vector2(mouseCoords.x, mouseCoords.y) # Gets angle to point based on where the mouse is
	angle = direction.angle()
	if(fmod(abs(rad2deg(angle)), 180) > 90): # If the spear is thrown to the left
		$Sprite.scale = Vector2($Sprite.scale.x, -$Sprite.scale.y)
	
	rotation = angle # sets initial rotation
	position = playerPos # sets initial position
	linear_velocity = direction.normalized() * speed # sets initial velocity
	if rad2deg(angle) < -90:
		angular_velocity = -1
	if rad2deg(angle) > -90:
		angular_velocity = 1
	show() # show the spear now that it is positioned correctly


func _unhandled_input(event):
	if(mouseIn && stuck && Input.is_action_just_pressed("mouseLeft")):
		collectSpear()


func _physics_process(delta):
	# If the spear has stopped moving, freeze it and make it collectable.
	if(!stuck && linear_velocity.length() <= error):
		stick_spear()
		


# Runs when the tip of the spear collides with an object
func _on_TipCollision_body_entered(body):
	if(!stuck && body.is_in_group("spear_can_stick") && (abs(rad2deg(transform.get_rotation()))) < stick_angle || abs(rad2deg(transform.get_rotation())) > 180-stick_angle):
		stick_spear()


func stick_spear():
	#print("STUCK")
	stuck = true
	set_deferred("mode", RigidBody2D.MODE_STATIC) # Set static so the spear no longer moves
	if(!$BodyCollision.colliding): # If the spear is not laying flat on the ground
		# updates collision layers so that the spear can collide with the player
		set_collision_layer_bit(2, true)
		set_collision_mask_bit(2, true)
		set_collision_layer_bit(1, true)
		set_collision_mask_bit(1, true)


func collectSpear():
	emit_signal("spear_collected")
	queue_free()


func _on_Spear_mouse_entered():
	mouseIn = true


func _on_Spear_mouse_exited():
	mouseIn = false
