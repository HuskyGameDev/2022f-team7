extends Control

func _on_player_health_changed(player_hearts):
	$hearts.frame = player_hearts
