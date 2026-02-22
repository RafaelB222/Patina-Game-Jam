extends Control

@onready var player = load("res://Player/player.tscn")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory") and self.visible == false:
		self.visible = true
	else:
			if Input.is_action_just_pressed("inventory"):
				self.visible = false

##make sprites appear depending on what you have
