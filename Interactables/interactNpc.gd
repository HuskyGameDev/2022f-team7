extends "res://Interactables/interactBase.gd"



func _ready():
	._ready() #super call

func dialog():
	.dialog()#interacting is set here so be careful
	$AnimatedSprite.playing = interacting
	if !interacting: $AnimatedSprite.frame = 0

