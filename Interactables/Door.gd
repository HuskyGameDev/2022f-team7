extends KinematicBody2D




func _on_SwitchPuzzle_switchActivated(check):
	self.visible = !check
	get_node("CollisionShape2D").disabled = check
