extends Node2D

var player = preload("res://Player/player.tscn")

var activePlayer
var currentExit
var levelDir
var level:Node2D
var interactArea:Area2D

func _ready():
	$pauseScreen.visible = false
	$deathScreen.visible = false
	$main.visible = true

func _on_resume_pressed():
	get_tree().paused = false
	$pauseScreen.hide()

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

func _on_deathTimer_timeout():
	activePlayer.get_node("./Camera2D/hud").hide()
	$deathScreen.visible = true
	get_tree().paused = true
	

func _on_level_complete():
	pass

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause_game") && !$main.visible:
		$pauseScreen.visible = !$pauseScreen.visible
		get_tree().paused = !get_tree().paused

func createLevel():
	level = load(levelDir).instance()
	add_child(level)

func createPlayer():
	activePlayer = player.instance()
	if level.get_node("playerSpawn") != null:
		activePlayer.position = level.get_node("playerSpawn").position
	level.add_child(activePlayer)
	activePlayer.connect("health_changed",self,"_on_healthChanged")
	activePlayer.connect("interacting",self,"interactHandler")

# creates exit in same style as player
func createExit():
	#currentExit = elevatorExit.instance()
	pass


#anticipate deprecation: don't use
func interactHandler(interact_with):
	if interact_with.is_in_group("interactable"):
		interactArea = interact_with
		
		

