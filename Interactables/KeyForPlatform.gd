extends Node2D

signal ActivatedMovingPlatforms
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	if(area.is_in_group("player")):
		emit_signal("ActivatedMovingPlatforms")
		queue_free() # Replace with function body.
