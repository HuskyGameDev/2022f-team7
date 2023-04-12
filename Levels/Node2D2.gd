extends Node2D


const enemy = preload("res://Enemies/mrStab.tscn")


func _on_Timer_timeout():
	var player = get_parent().get_node("player")

	var thing = enemy.instance()
	self.add_child(thing)
	thing._onStartEnter(player)
