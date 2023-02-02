extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var SwitchOn
var inRange

signal switchActivated(check)

# Called when the node enters the scene tree for the first time.
func _ready():
	SwitchOn = false
	inRange = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if(event.is_action_pressed("interact") && inRange):
		if(SwitchOn==false):
			SwitchOn == true
			emit_signal("switchActivated",true)
		elif(SwitchOn == true):
			SwitchOn == false
			emit_signal("switchActivated",false)


func _on_Area2D_area_entered(area):
	if(area.is_in_group("player")):
		inRange = true
	
