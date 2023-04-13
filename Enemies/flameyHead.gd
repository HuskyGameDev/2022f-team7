extends "res://Enemies/baseEnemy.gd"

func custom(_delta):
	# $AnimatedSprite.frame = engaged
	pass

func customMode(_delta): 
	pass

func _ready():
	$Ambiance.playing = true;
	$TrailParticles.emitting = true;
	$SloppyFace.visible = false;


func _on_Ambiance_finished():
	$Ambiance.playing = true;

func _on_hitbox_area_entered(area):
	if(area.is_in_group('spear')):
		$DeathSound.play(0.31)
		reparent($DeathSound)
		$TrailParticles.emitting = false;
		reparent($TrailParticles)
		$DeathParticles.emitting = true;
		$DeathParticles/DeathTimer.start()
		reparent($DeathParticles)
		queue_free()

func reparent(var node):
	remove_child(node)
	get_parent().add_child(node)
	node.transform = transform
