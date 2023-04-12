extends "res://Enemies/baseEnemy.gd"


func custom(_delta):
	$AnimatedSprite.frame = engaged

func customMode(_delta): 
	pass

func _ready():
	$Ambiance.playing = true;


func _on_Ambiance_finished():
	$Ambiance.playing = true;

func _on_hitbox_area_entered(area):
	if(area.is_in_group('spear')):
		var ds = $DeathSound
		remove_child(ds)
		get_parent().add_child(ds)
		ds.transform = transform
		ds.play(0.31)
		queue_free()
