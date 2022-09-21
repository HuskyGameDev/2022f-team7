extends Control

#amount of pixels per heart
var heartSize = 80

#if there is some sort of change to the players health whether it be a heal or damaged
func on_player_changed(player_hearts: int):
	$hearts.rect_size.x = player_hearts *  heartSize

