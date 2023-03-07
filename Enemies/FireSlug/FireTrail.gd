extends Area2D


func _on_Lifetime_timeout():
	queue_free();
