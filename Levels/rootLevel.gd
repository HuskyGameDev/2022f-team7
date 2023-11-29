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
	$Black/ColorRect.modulate = Color.transparent
	$Black.visible = false

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
	
	$deathScreen.hide()
	$pauseScreen.hide()
	levelTransition(levelDir)

func _on_quit_pressed():
	get_tree().quit()

func _on_menu_pressed():
	$main/levelSelect.hide()
	$main/playScreen.show()
	levelTransition("lastLevel")
 
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
		print("pause!")
		pauseControl()

func pauseControl():
	if  !$deathScreen/deathTimer.is_stopped() || $deathScreen.visible || $Black.visible:
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
	$LevelContainer.add_child(level)
	if !$AudioStreamPlayer.playing:
		$AudioStreamPlayer.playing = true
	$AudioStreamPlayer.stream_paused = false

func createPlayer():
	activePlayer = player.instance()
	if level.get_node_or_null("playerSpawn") != null:
		activePlayer.position = level.get_node("playerSpawn").position
	level.add_child(activePlayer)
	activePlayer.connect("health_changed",self,"_on_healthChanged")

func levelTransition(nextLevel):
	$Black.show()
	$pauseScreen.hide()
	$optionsScreen.hide()
	$Fade.interpolate_property($Black/ColorRect, "modulate", Color.transparent, Color.black, 0.4, Tween.TRANS_SINE, Tween.EASE_IN)
	$Fade.start()
	yield($Fade, "tween_completed")
	#check if a level is loaded in
	if $LevelContainer.get_child_count() > 0:
		level.queue_free()
		activePlayer.queue_free()
	if nextLevel == "lastLevel":
		$AudioStreamPlayer.playing = false
		$deathScreen.hide()
		$pauseScreen.hide()
		$main.show()
		$Fade.interpolate_property($Black/ColorRect, "modulate", Color.black, Color.transparent, 0.4, Tween.TRANS_SINE, Tween.EASE_IN)
		$Fade.start()
		yield($Fade, "tween_completed")
		$Black.hide()
		return
	load_level(nextLevel)
	get_tree().paused = false
	$Fade.interpolate_property($Black/ColorRect, "modulate", Color.black, Color.transparent, 0.4, Tween.TRANS_SINE, Tween.EASE_IN)
	$Fade.start()
	yield($Fade, "tween_completed")
	$Black.hide()
	if nextLevel == "res://Levels/level1-Boss.tscn":
		$AudioStreamPlayer.stop()

func levelcompleted(nextLevel, levelindex):
	$main.unlockLevel(levelindex)
	levelTransition(nextLevel)


func onSplashEnd():
	$Fade.interpolate_property($Splash/Sprite, "modulate", Color.white, Color.transparent, 0.4, Tween.TRANS_SINE, Tween.EASE_IN)
	$Fade.start()
