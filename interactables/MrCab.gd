extends KinematicBody2D


export var direction = false # False for left, true for right.
export var speed = 15
export var gravity = 2.5
export var ray_near_cast = 5
export var ray_far_cast = 17
export var npc = false #if mr cab has anything to say
var cooldown = false # Cooldown so that Mr.Cab doesn't spam direction changes
var spear_attached = false
var spear_direction = false # false if the spear is attached to the left side, true if attached to the right side
var yvel = 0


func _ready():
	$AnimatedSprite.flip_h = direction;
	$AnimatedSprite.play("walk");
	speed = abs(speed) if direction else -abs(speed);
	$RayCast2D.cast_to = Vector2(abs($RayCast2D.cast_to.x), 0) if direction else Vector2(-abs($RayCast2D.cast_to.x), 0)


func _physics_process(delta):
	if($RayCast2D.get_collider() != null && $RayCast2D.get_collider().name != "Spear" && !cooldown) : 
		flipDirection()
	yvel += gravity if !is_on_floor() else 0
	yvel = clamp(yvel, -10000, 600)
	move_and_slide(Vector2(speed, yvel), Vector2.UP)


func flipDirection():
	direction = !direction
	$AnimatedSprite.flip_h = direction;
	speed = abs(speed) if direction else -abs(speed);
	update_ray()
	$Cooldown.start()
	cooldown = true;


func _on_Cooldown_timeout():
	cooldown = false

# Updates the direction and length of the raycast, depending on the direction and spear_attached variables
func update_ray():
	if(spear_attached):
		if(direction):
			$RayCast2D.cast_to = Vector2(ray_far_cast, 0) if spear_direction else Vector2(ray_near_cast, 0)
		else:
			$RayCast2D.cast_to = Vector2(-ray_far_cast, 0) if !spear_direction else Vector2(-ray_near_cast, 0)
	else:
		$RayCast2D.cast_to = Vector2(ray_near_cast, 0) if direction else Vector2(-ray_near_cast, 0)


# Called when the spear collides with Mr. Cab
func _on_SpearDetection_body_entered(body):
	if(!spear_attached && body.name == "Spear"):
		body.connect("spear_collected", self, "remove_spear")
		spear_direction = false if body.global_position.x < global_position.x else true
		spear_attached = true
		update_ray()


# Called when the player collects the spear
func remove_spear():
	spear_attached = false
	update_ray()
