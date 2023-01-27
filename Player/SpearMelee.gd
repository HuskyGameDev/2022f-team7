extends KinematicBody2D

var distance = 12; # Length of poke
var speed = 60; # Speed to move spear
var direction; # Stores mouse coordinates
var angle; # Stores angle to poke
var startPos = Vector2.ZERO; # Stores start position
var endPos = Vector2.ZERO; # Stores end position

signal spear_attack_ended # signal emitted when attack is finished


func start(mouseCoords):
	direction = Vector2(mouseCoords.x, mouseCoords.y) # Gets angle to point based on where the mouse is
	angle = direction.angle();
	rotation = angle; # Set initial rotation to angle
	startPos = position; # Store initial position
	
	if(fmod(abs(rad2deg(angle)), 180) < 90): # Flip spear vertially if poking to the right
		$Sprite.transform.y.y = -0.5;

func _physics_process(delta):
	move_and_slide(direction.normalized() * speed, Vector2(0, 1), false);
	# If the spear has moved past the set distance
	if startPos.distance_to(position) > distance && speed > 0:
		endPos = position;
		speed = -speed;
	# If spear has moved back past original position
	if(speed < 0 && position.distance_to(endPos) >= distance):
		emit_signal("spear_attack_ended");
		queue_free();
