extends Node2D

signal ActivatedMovingPlatforms

func _on_Area2D_area_entered(area):
	if(area.is_in_group("player")):
		emit_signal("ActivatedMovingPlatforms")
		queue_free()
