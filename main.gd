extends Control



func _ready():
	#just in case these are set wrong when in editor
	$levelSelect.visible = false
	$playScreen.visible = true

func _on_play_pressed():
	$playScreen.visible = false
	$levelSelect.visible = true

func _on_back_pressed():
	$levelSelect.visible = false
	$playScreen.visible = true
	
func _on_pause_pressed():
	print("paused")
	get_tree().pause = true
	$pauseScreen.visible = true
		

func _on_return_pressed():
	get_tree().pause = false
	$pauseScreen.visible = false


func _on_quit_pressed():
	get_tree().quit()


func _on_Debug_pressed():
	get_tree().change_scene("res://levels/debug level.tscn")
