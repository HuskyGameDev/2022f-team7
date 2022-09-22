extends Node2D



#root level scene for game state management controller, empty because I'm not
#assigned to this stuff and don't want to overreach again :) -soup
signal game_paused

func _ready():
	$pauseScreen.visible = false
	
func _on_resume_pressed():
	print("returnpressed")
	get_tree().paused = false
	$pauseScreen.visible = false

func _on_quit_pressed():
	print("quitpressed")
	get_tree().quit()

func _on_levelRoot_game_paused():
	$pauseScreen.visible = !$pauseScreen.visible
	get_tree().paused = !get_tree().paused


func _on_menu_pressed():
	get_tree().change_scene("res://main.tscn")
	get_tree().paused = false

	
func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause_game"):
		emit_signal("game_paused")


func _on_game_paused():
	pass # Replace with function body.
