extends KinematicBody2D

var distance = 12; # Length of poke
var speed = 90; # Speed to move spear
var direction; # Stores mouse coordinates
var angle; # Stores angle to poke
var startPos = Vector2.ZERO; # Stores start position
var endPos = Vector2.ZERO; # Stores end position
var state = 0;

signal spear_attack_ended # signal emitted when attack is finished


func start(mouseCoords, s):
	state = s;
	set_color();
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

func set_color():
	if(state == 0):
		$Sprite.modulate = Color(1, 1, 1);
	elif(state == 1):
		$Sprite.modulate = Color(0.83, 0.38, 0.38);
	elif(state == 2):
		$Sprite.modulate = Color(0.92, 0.92, 0.15);
	elif(state == 3):
		$Sprite.modulate = Color(0.41, 0.41, 1.0);


func _on_SpearTip_area_entered(area):
	if(state == 1 && !area.is_in_group("player")): $AOEattack.start();


func _on_SpearTip_body_entered(body):
	if(state == 1 && !body.is_in_group("player")): $AOEattack.start();
