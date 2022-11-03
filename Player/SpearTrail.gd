extends Particles2D


# Declare member variables here. Examples:
var direction
var target
var speed = 5

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
		emitting = false
	else:
		global_position = global_position.move_toward(target, speed)


func _on_Delay_timeout():
	queue_free()
