extends AudioStreamPlayer2D

#KILL YOURSELF, NOW
func _on_DeathSound_finished():
	print("EXPLODE")
	print(get_parent().name)
	queue_free()
