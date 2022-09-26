extends Node2D

var player = preload("res://Player/player.tscn")

var activePlayer
var level

func load_level(levelPath):
	level = load(levelPath).instance()
	add_child(level)
	activePlayer = player.instance()
	level.add_child(activePlayer)
	$Main.hide()

func _on_player_death():
	pass

func _on_level_complete():
	pass

func _ready():
	$pauseScreen.visible = false

func _on_resume_pressed():
	print("returnpressed")
	get_tree().paused = false
	$pauseScreen.visible = false

func _on_quit_pressed():
	print("quitpressed")
	get_tree().quit()

func _on_menu_pressed():
	level.queue_free()
	activePlayer.queue_free()
	$pauseScreen.hide()
	$Main.show()
	get_tree().paused = false

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause_game") && !$Main.visible:
		$pauseScreen.visible = !$pauseScreen.visible
		get_tree().paused = !get_tree().paused
