extends Node2D



#root level scene for game state management controller, empty because I'm not
#assigned to this stuff and don't want to overreach again :) -soup
signal game_paused

func _ready():
	$GUI/pauseScreen.visible = false
	
func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause_game"):
		emit_signal("game_paused")
