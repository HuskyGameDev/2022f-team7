extends CanvasLayer

func _ready():
	#just in case these are set wrong when in editor
	$levelSelect.visible = false
	$playScreen.visible = true

func _on_play_pressed():
	$playScreen.visible = false
	$levelSelect.visible = true

func _on_back_pressed():
	$levelSelect.visible = false
	$controlsScreen.visible = false
	$playScreen.visible = true

func _on_controls_pressed():
	$playScreen.visible = false
	$controlsScreen.visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_Debug_pressed():
	get_tree().get_root().get_child(0).load_level("res://Levels/debugLevel.tscn")
	

func _on_levelOne_pressed():
	get_tree().get_root().get_child(0).load_level("res://Levels/level1-1.tscn")
	
func _on_levelTwo_pressed():
	get_tree().get_root().get_child(0).load_level("res://Levels/level1-2.tscn")
	
func _on_levelThree_pressed():
	get_tree().get_root().get_child(0).load_level("res://Levels/level1-3.tscn")

func _on_levelFour_pressed():
	get_tree().get_root().get_child(0).load_level("res://Levels/level1-4.tscn")
	
func _on_levelFive_pressed():
	get_tree().get_root().get_child(0).load_level("res://Levels/level1-5.tscn")
	
func _on_levelSix_pressed():
	get_tree().get_root().get_child(0).load_level("res://Levels/level2-1.tscn")

func _on_tutorialLevel_pressed():
	get_tree().get_root().get_child(0).load_level("res://Levels/tutorialLevel.tscn")
