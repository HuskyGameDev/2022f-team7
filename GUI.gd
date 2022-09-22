extends CanvasLayer

func _on_return_pressed():
	print("returnpressed")
	get_tree().pause = false
	$pauseScreen.visible = false

func _on_quit_pressed():
	print("quitpressed")
	get_tree().quit()

func _on_levelRoot_game_paused():
	$pauseScreen.visible = !$pauseScreen.visible
	get_tree().paused = !get_tree().paused
