extends Control

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory") and self.visible == false:
		self.visible = true
	else:
			if Input.is_action_just_pressed("inventory"):
				self.visible = false
