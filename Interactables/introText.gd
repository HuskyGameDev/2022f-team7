extends "res://Interactables/interactBase.gd"

var levelRoot
export (String) var nextLevel
signal change_level(next_level)

func _ready():
	$AudioStreamPlayer.stream = null
	if get_tree().get_root().get_child(0).get_name() == "levelRoot":
		print("connecting")
		levelRoot = get_tree().get_root().get_child(0)
		var result = connect("change_level", levelRoot, "levelcompleted")
		if result != OK:
			push_error("the exit device could not connect!")
	._ready() #super call
	
	dialog()

func _input(event):
	if pauseScreen.visible:
			return
	get_tree().paused = true
	
	if event.is_action_pressed("interact"):
		dialog()

func dialog():
	if pauseScreen.visible:
			return
	.dialog()#interacting is set here so be careful

func dialogEnd():
	print("end!")
	.dialogEnd()
	emit_signal("change_level", nextLevel, 0)
