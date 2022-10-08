extends Node2D

var player = preload("res://Player/player.tscn")

var activePlayer
var levelDir
var level

func _ready():
	$pauseScreen.visible = false
	$main.visible = true
	#$deathScreen.visible = false

func _on_resume_pressed():
	get_tree().paused = false
	$pauseScreen.hide()

func _on_restart_pressed():
	level.queue_free() #clear out player and level instances
	activePlayer.queue_free()
	
	level = load(levelDir).instance() #reload level entirely
	add_child(level)
	activePlayer = player.instance()
	level.add_child(activePlayer)
	
	get_tree().paused = false #unpause
	$pauseScreen.hide()

func _on_quit_pressed():
	get_tree().quit()

func _on_menu_pressed():
	level.queue_free()
	activePlayer.queue_free()
	$pauseScreen.hide()
	$main.show()
	get_tree().paused = false
 
func load_level(levelPath):
	levelDir = levelPath
	level = load(levelDir).instance()
	add_child(level)
	activePlayer = player.instance()
	level.add_child(activePlayer)
	$main.hide()

func _on_player_death():
	get_tree().paused = true
	$deathScreenTimer.start()
	
func _on_deathScreenTimer_timeout():
	$deathScreen.visible = true
	

func _on_level_complete():
	pass

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause_game") && !$main.visible:
		$pauseScreen.visible = !$pauseScreen.visible
		get_tree().paused = !get_tree().paused
