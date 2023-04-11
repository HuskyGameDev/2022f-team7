extends KinematicBody2D




func _on_SwitchPuzzle_switchActivated(check):
	$StaticBody2D.visible = !check
	$StaticBody2D.set_collision_layer_bit(0, !check)
