extends Control

#amount of pixels per heart (subject to change based on actual heart sizes used)
var heartSize = 80

#if there is some sort of change to the players health whether it be a heal or damaged
func on_player_health_changed(player_hearts: int) -> void:
	$hearts.rect_size.x = player_hearts * heartSize

