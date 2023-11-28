extends "res://Interactables/interactBase.gd"

var levelRoot;

export (String) var nextLevel
export var levelindex = -1
signal change_level(next_level)

func _ready():
	if get_tree().get_root().get_child(0).get_name() == "levelRoot":
		print("connecting")
		levelRoot = get_tree().get_root().get_child(0)
		var result = connect("change_level", levelRoot, "levelcompleted")
		if result != OK:
			push_error("the exit device could not connect!")
	
	._ready() #super call

func _on_option1_pressed():
	$CanvasInteractions/popup.hide()
	print(get_parent().name)
	get_tree().paused = false
	#the player has to exist so no risk of breakage
	get_parent().get_node("player").hide()
	get_parent().get_node("player").isDying =  true
	$Sprite.play("nextLevel")
	#emit_signal("change_level", nextLevel)

func _on_option2_pressed():
	$CanvasInteractions/popup.hide()
	get_tree().paused = false


func _on_Sprite_animation_finished():
	$Tween.interpolate_property($Sprite, "position", $Sprite.position, Vector2(0, -60), 1, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()


func _on_Tween_tween_all_completed():
	emit_signal("change_level", nextLevel, levelindex)
