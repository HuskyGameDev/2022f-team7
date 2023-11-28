extends Area2D

func _input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("mouseLeft"):
		self.get_parent().collectSpear()
