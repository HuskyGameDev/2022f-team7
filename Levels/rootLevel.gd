extends Node2D

var player = preload("res://Player/player.tscn")

var activePlayer
var level

func _ready():
	$pauseScreen.visible = false
	$main.visible = true
	#$deathScreen.visible = false

func _on_resume_pressed():
	print("returnpressed")
	get_tree().paused = false
	$pauseScreen.hide()
	
#func _on_restart_pressed():

func _on_restart_pressed():
	pass #this doesn't do anything rn
	

func _on_quit_pressed():
	get_tree().quit()

func _on_menu_pressed():
	$level.queue_free()
	$activePlayer.queue_free()
	$levelRoot/pauseScreen.hide()
	$main.show()
	get_tree().paused = false
 

func load_level(levelPath):
	level = load(levelPath).instance()
	add_child(level)
	activePlayer = player.instance()
	level.add_child(activePlayer)
	$main.hide()

func _on_player_death():
	pass

func _on_level_complete():
	pass

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause_game") && !$main.visible:
		$pauseScreen.visible = !$pauseScreen.visible
		get_tree().paused = !get_tree().paused
