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



func _on_quit_pressed():
	get_tree().quit()
