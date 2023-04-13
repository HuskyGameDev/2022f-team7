extends AudioStreamPlayer2D

#KILL YOURSELF, NOW
func _on_DeathSound_finished():
	queue_free()
