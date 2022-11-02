extends KinematicBody2D


# Declare member variables here. Examples:
var direction
var target
var speed = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	target = $"../player".global_position
	direction = global_position.direction_to(target).normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	target = $"../player".global_position
	direction = global_position.direction_to(target).normalized()
	if(position.distance_to(target) < 5):
		$Delay.start()
		$Particles2D.emitting = false
	else:
		move_and_slide(direction * speed, Vector2.UP)


func _on_Delay_timeout():
	queue_free()
