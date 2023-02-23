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
var stuck = false # Stores whether or not the spear is "stuck" to an object
var mouseIn = false # Stores whether or not the mouse is touching the spear
var state = 0; # Whether the spear is normal (0), red (1), yellow (2), or blue (3)
var homing_speed = 4; # Speed multipler to home in on targets
var enemies = []; # Array of enemies in scene to home in on
var enemy; # Selected enemy to home in on
var homing = true; # Whether or not an enemy can be found to home in on
export var homing_distance = 100; # Distance an enemy has to be to the spear for homing to work

signal spear_collected # Signal emitted when the spear is collected




#TODO: pixel perfect movement, sprites instead of rotation to fit art style

func start(mouseCoords, pos, vec, s):
	state = s
	set_color()
	if(state == 3): set_collision_mask_bit(4, false);
	if(state == 2):
		get_enemies(get_tree().current_scene)
		enemy = get_closest_enemy(get_global_mouse_position());
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
	# If the player clicked on the spear OR pressed "Q", return the spear to the player
	if(Input.is_action_just_pressed("spear_retrieve")):
		collectSpear()


func _physics_process(_delta):
	# home in on an enemy if in state 2
	if(state == 2 && is_instance_valid(enemy) && homing && !stuck):
		linear_velocity = lerp(linear_velocity, global_position.direction_to(enemy.global_position) * (speed / 2), 0.1);
		rotation = global_position.direction_to(enemy.global_position).angle()
	
	# If the spear has stopped moving, freeze it and make it collectable.
	if(!stuck && linear_velocity.length() <= error):
		stick_spear()


# Runs when the tip of the spear collides with an object
func _on_TipCollision_body_entered(body):
	if(state == 1 && !body.is_in_group("player")): AOEattack();
	if(!stuck && body.is_in_group("spear_can_stick") && ((abs(rad2deg(transform.get_rotation()))) < stick_angle || abs(rad2deg(transform.get_rotation())) > 180-stick_angle)):
		stick_spear()


func _on_TipCollision_area_entered(area):
	if(state == 1 && !area.is_in_group("player") && !area.name == "collectArea"): AOEattack();
	if(!stuck && area.is_in_group("spear_can_attach") && ((abs(rad2deg(transform.get_rotation()))) < stick_angle || abs(rad2deg(transform.get_rotation())) > 180-stick_angle)):
		call_deferred("attach_spear", area)


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

# Attaches the spear to a different parent. 
# Makes the spear inherit it's new parents' position and collidable with the player
func attach_spear(var area):
	var pos = global_position
	stuck = true
	get_parent().remove_child(self)
	area.add_child(self)
	global_position = pos
	mode = RigidBody2D.MODE_KINEMATIC
	# Update collision layers
	self.set_collision_layer_bit(4, true)
	#self.set_collision_mask_bit(0, false)
	$collectArea.set_collision_layer_bit(0, false)

func set_color():
	if(state == 0):
		$Sprite.modulate = Color(1, 1, 1);
	elif(state == 1):
		$Sprite.modulate = Color(0.83, 0.38, 0.38);
	elif(state == 2):
		$Sprite.modulate = Color(0.92, 0.92, 0.15);
	elif(state == 3):
		$Sprite.modulate = Color(0.41, 0.41, 1.0);

func AOEattack():
	$AOEattack.start();

# Recursively gets all enemies that currently exist in the scene tree
# Nodes considered enemies are those that exist on collision layer 5
func get_enemies(var node):
	if(node is CollisionObject2D && node.get_collision_layer_bit(4)): enemies.append(node);
	if(node.get_child_count() == 0): return;
	for n in node.get_children():
		get_enemies(n)

# Gets the closest enemy to the provided vector and returns it
func get_closest_enemy(var v):
	var distance = null;
	var n = null;
	for e in enemies:
		# Distance formula go brrrrrrr (the distance_to function didn't work. Don't ask why. I still don't know)
		var d = sqrt(pow(v.x - e.global_position.x, 2) + pow(v.y - e.global_position.y, 2))
		if distance == null || d < distance: 
			distance = d; 
			n = e;
	if(distance == null || distance > homing_distance): homing = false;
	return n;
