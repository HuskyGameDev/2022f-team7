extends Area2D

func _ready():
	$AOEparticles.emitting = false;

func start():
	$AOEparticles.emitting = true;
	$AOEtimer.start();
	set_collision_layer_bit(3, true);

func end():
	set_collision_layer_bit(3, false);
