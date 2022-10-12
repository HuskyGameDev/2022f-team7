extends Control

#amount of pixels per heart (subject to change based on actual pixel sizes used) (x direction btw)
var heartSize = 496

#if there is some sort of change to the players health whether it be a heal or damaged
func _on_player_health_changed(player_hearts):
	$hearts.rect_size.x = player_hearts*heartSize
