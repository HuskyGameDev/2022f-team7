extends Node2D

var explosionArea;

# Called when the node enters the scene tree for the first time.
func _ready():
	$WarningParticles.emitting = false;
	$ExplosionParticles.emitting = false;
	explosionArea = $ExplosionArea;
	remove_child(explosionArea);


func _on_WarningTimer_timeout():
	add_child(explosionArea);
	$WarningParticles.emitting = false;
	$ExplosionParticles.emitting = true;
	$ExplosionTimer.start();


func _on_ExplosionTimer_timeout():
	remove_child(explosionArea);
	$ExplosionParticles.emitting = false;
	$DelayTimer.start();


func _on_DelayTimer_timeout():
	$WarningParticles.emitting = true;
	$WarningTimer.start();
