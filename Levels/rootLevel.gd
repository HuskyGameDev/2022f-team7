extends Node2D

var player = preload("res://Player/player.tscn")

var activePlayer
var currentExit
var levelDir
var level:Node2D
var alreadyPaused
var optionsOpened

func _ready():
	$pauseScreen.visible = false
	$deathScreen.visible = false
	$main.visible = true
	$optionsScreen.visible = false

func _on_resume_pressed():
	pauseControl()

func _on_mute_pressed():
	$AudioStreamPlayer.playing = !$AudioStreamPlayer.playing

func _on_options_pressed():
	$pauseScreen.hide()
	$optionsScreen.show()

func _on_pauseBack_pressed():
	$optionsScreen.hide()
	$pauseScreen.show()

func _on_restart_pressed():
	level.queue_free() #clear out player and level instances
	activePlayer.queue_free()
	
	createLevel()
	createPlayer()
	
	get_tree().paused = false #unpause
	$deathScreen.hide()
	$pauseScreen.hide()

func _on_quit_pressed():
	get_tree().quit()

func _on_menu_pressed():
	level.queue_free()
	activePlayer.queue_free()
	$AudioStreamPlayer.playing = false
	
	$deathScreen.hide()
	$pauseScreen.hide()
	$main.show()
	get_tree().paused = false
 
func load_level(levelPath):
	levelDir = levelPath
	createLevel()
	createPlayer()
	$main.hide()


func _on_healthChanged(player_hearts):
	if (player_hearts <= 0):
		print('dead')
		$deathScreen/deathTimer.start()
		$AudioStreamPlayer.playing = false

func _on_deathTimer_timeout():
	activePlayer.get_node("./Camera2D/hud").hide()
	$deathScreen.visible = true
	get_tree().paused = true

func _on_level_complete():
	pass

func _input(_event):
	if Input.is_action_just_pressed("pause_game") && $main.visible == false && $deathScreen.visible == false:
		pauseControl()

func pauseControl():
	if  !$deathScreen/deathTimer.is_stopped() || $deathScreen.visible:
		return
	optionsOpened = false
	if $pauseScreen.visible == false and $optionsScreen.visible == false:
		alreadyPaused = (get_tree().paused)
	
	elif $pauseScreen.visible == false and $optionsScreen.visible == true:
		$optionsScreen.visible = false
		optionsOpened = true
		
	$pauseScreen.visible = !$pauseScreen.visible
	if optionsOpened == false:
		$AudioStreamPlayer.stream_paused = !$AudioStreamPlayer.stream_paused
		activePlayer.get_node("./Camera2D/hud").visible = !activePlayer.get_node("./Camera2D/hud").visible
	
	if !alreadyPaused:
		get_tree().paused = $pauseScreen.visible

func createLevel():
	level = load(levelDir).instance()
	add_child(level)
	$AudioStreamPlayer.playing = true
	$AudioStreamPlayer.stream_paused = false

func createPlayer():
	activePlayer = player.instance()
	if level.get_node("playerSpawn") != null:
		activePlayer.position = level.get_node("playerSpawn").position
	level.add_child(activePlayer)
	activePlayer.connect("health_changed",self,"_on_healthChanged")
	
func levelTransition(nextLevel):
	level.queue_free()
	activePlayer.queue_free()
	get_tree().paused = false
	if nextLevel == "lastLevel":
		$AudioStreamPlayer.playing = false
		$deathScreen.hide()
		$pauseScreen.hide()
		$main.show()
		return
	load_level(nextLevel)
