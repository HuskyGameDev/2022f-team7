extends CanvasLayer

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
