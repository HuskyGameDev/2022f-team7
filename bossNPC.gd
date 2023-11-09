extends "res://Interactables/interactBase.gd"

export(PackedScene) var boss

func _ready():
	._ready()

func _on_body_entered(body):
	._on_body_entered(body)
	if pauseScreen.visible:
			print("other process in progress")
			return
		
	if pauseTree:
		get_tree().paused = true
	
	dialog()

func dialogEnd():
	var inst = boss.instance()
	inst.position = self.position
	get_parent().add_child(inst)
	queue_free()
