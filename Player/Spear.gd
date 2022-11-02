extends RigidBody2D


# Declare member variables here
export (PackedScene) var particles
export (PackedScene) var particleTrail

export var speed = 200 # Initial speed with which the spear is thrown
export var stick_angle = 40 # angle within which the spear will stick to walls
export var error = 0.05 # The error when checking if velocity is zero
var angle # Initial angle at which to travel
var direction # Stores mouse coordinates
var playerPos # Stores player coordinates
var stuck = false # Stores whether or not the spear is "stuck" (collectable)
var mouseIn = false # Stores whether or not the mouse is touching the spear

signal spear_collected # Signal emitted when the spear is collected




#TODO: pixel perfect movement, sprites instead of rotation to fit art style

func start(mouseCoords, pos, vec):
	hide() # Hide the spear while it is being positioned
	playerPos = pos # Set initial position to player position
	direction = Vector2(mouseCoords.x, mouseCoords.y) # Gets angle to point based on where the mouse is
	angle = direction.angle()
	if(fmod(abs(rad2deg(angle)), 180) > 90): # If the spear is thrown to the left, flip the sprite
		$Sprite.scale = Vector2($Sprite.scale.x, -$Sprite.scale.y)
	# Set inital values
	rotation = angle # sets initial rotation
	position = playerPos # sets initial position
	linear_velocity = (direction.normalized() * speed) + vec # sets initial velocity
	angular_velocity = -1 if rad2deg(angle) <= -90 else 1
	show() # show the spear now that it is positioned correctly


func _unhandled_input(_event):
	# If the player clicked on the spear OR pressed "E" while stuck, return the spear to the player
	if(Input.is_action_just_pressed("spear_retrieve") && stuck):
		collectSpear()


func _physics_process(_delta):
	# If the spear has stopped moving, freeze it and make it collectable.
	if(!stuck && linear_velocity.length() <= error):
		stick_spear()


# Runs when the tip of the spear collides with an object
func _on_TipCollision_body_entered(body):
	print("tip touched! " + body.name)
	if(!stuck && body.is_in_group("spear_can_stick") && (abs(rad2deg(transform.get_rotation()))) < stick_angle || abs(rad2deg(transform.get_rotation())) > 180-stick_angle):
		stick_spear()


# Attaches the spear to a wall or floor. Makes the spear static and collidable with the player.
func stick_spear():
	stuck = true
	set_deferred("mode", RigidBody2D.MODE_STATIC) # Set static so the spear no longer moves
	if(!$BodyCollision.colliding): # If the spear is not laying flat on the ground
		# updates collision layers so that the spear can collide with the player
		pass
		self.set_collision_layer_bit(0, true)
		self.set_collision_mask_bit(0, false)

# Returns the spear to the player
func collectSpear():
	emit_signal("spear_collected")
	var p = particles.instance()
	p.transform = transform
	get_parent().add_child(p)
	p.emitting = true;
	var t = particleTrail.instance()
	t.transform = transform
	get_parent().add_child(t)
	queue_free()
