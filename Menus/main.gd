extends CanvasLayer

export var levelsUnlocked = 0
onready var buttons = $levelSelect/ScrollContainer/GridContainer.get_children()

func _ready():
	#just in case these are set wrong when in editor
	$levelSelect.visible = false
	$playScreen.visible = true
	
	push_error("the game is running in debug mode, uncomment the lines after this assertion to change that.")
	#for n in buttons:
	#	n.disabled = true

func unlockLevel(levelindex):
	print(levelsUnlocked, " : ", levelindex)
	if (levelindex != levelsUnlocked || levelindex == -1): 
		return
	buttons[levelsUnlocked].disabled = false
	levelsUnlocked += 1

func _on_play_pressed():
	for n in buttons:
		n.disabled = false
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
	get_tree().get_root().get_child(0).levelTransition("res://Levels/debugLevel.tscn")

func _on_levelOne_pressed():
	get_tree().get_root().get_child(0).levelTransition("res://Levels/level1-1.tscn")
	
func _on_levelTwo_pressed():
	get_tree().get_root().get_child(0).levelTransition("res://Levels/level1-2.tscn")
	
func _on_levelThree_pressed():
	get_tree().get_root().get_child(0).levelTransition("res://Levels/level1-3.tscn")

func _on_levelFour_pressed():
	get_tree().get_root().get_child(0).levelTransition("res://Levels/level1-4.tscn")
	
func _on_levelFive_pressed():
	get_tree().get_root().get_child(0).levelTransition("res://Levels/level1-5.tscn")
	
func _on_levelBoss_pressed():
	get_tree().get_root().get_child(0).levelTransition("res://Levels/level1-Boss.tscn")
	
func _on_levelSix_pressed():
	get_tree().get_root().get_child(0).levelTransition("res://Levels/level2-1.tscn")
	
func _on_levelSeven_pressed():
	get_tree().get_root().get_child(0).levelTransition("res://Levels/level2-2.tscn")
	
func _on_levelEight_pressed():
	get_tree().get_root().get_child(0).levelTransition("res://Levels/level2-3.tscn")

func _on_levelNine_pressed():
	get_tree().get_root().get_child(0).levelTransition("res://Levels/level2-4.tscn")
	
func _on_levelTen_pressed():
	get_tree().get_root().get_child(0).levelTransition("res://Levels/level2-5.tscn")

func _on_tutorialLevel_pressed():
	get_tree().get_root().get_child(0).levelTransition("res://Levels/tutorialLevel.tscn")

func _on_intro_pressed():
	get_tree().get_root().get_child(0).levelTransition("res://Levels/Intro.tscn")

func _on_start_pressed():
	if levelsUnlocked == 0:
		get_tree().get_root().get_child(0).levelTransition("res://Levels/Intro.tscn")
	else:
		$playScreen.visible = false
		$levelSelect.visible = true
