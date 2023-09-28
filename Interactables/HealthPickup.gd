extends Node2D


func _ready():
	#maybe add animation later here
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_hitbox_area_entered(area):
	#if(area.is_in_group("player")):
	print("hit player!");
	queue_free()
