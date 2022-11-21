extends KinematicBody2D


export var direction = false # False for left, true for right.
export var speed = 15
export var gravity = 50
var cooldown = false


func _ready():
	$AnimatedSprite.flip_h = direction;
	$AnimatedSprite.play("walk");
	speed = abs(speed) if direction else -abs(speed);
	$RayCast2D.cast_to = Vector2(abs($RayCast2D.cast_to.x), 0) if direction else Vector2(-abs($RayCast2D.cast_to.x), 0)


func _process(delta):
	var yvel = gravity if !is_on_floor() else 0
	move_and_slide(Vector2(speed, yvel), Vector2.UP)


func _physics_process(delta):
	if($RayCast2D.get_collider() != null && !cooldown) : flipDirection()


func flipDirection():
	print("flipping direction")
	direction = !direction
	$AnimatedSprite.flip_h = direction;
	speed = abs(speed) if direction else -abs(speed);
	$RayCast2D.cast_to = Vector2(abs($RayCast2D.cast_to.x), 0) if direction else Vector2(-abs($RayCast2D.cast_to.x), 0)
	$Cooldown.start()
	cooldown = true;


func _on_Cooldown_timeout():
	cooldown =false
