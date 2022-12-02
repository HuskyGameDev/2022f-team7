extends "res://interactables/interactBase.gd"

var levelRoot;

export (String) var nextLevel
signal change_level(next_level)

func _ready():
	if get_tree().get_root().get_child(0).get_name() == "levelRoot":
		print("connecting")
		levelRoot = get_tree().get_root().get_child(0)
		connect("change_level", levelRoot, "levelTransition")
	
	._ready() #super call

func _on_option1_pressed():
	emit_signal("change_level", nextLevel)

func _on_option2_pressed():
	get_tree().paused = false
	$CanvasInteractions/popup.hide()
