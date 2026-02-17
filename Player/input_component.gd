extends Node

signal move_command(direction)
signal basic_attack
signal jump
signal jump_released
signal dash
signal invert_gravity

var last_direction: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	handle_move_input(delta)

func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("left_click"):
		#basic_attack.emit()
	
	if event.is_action_pressed("ui_accept"):
		jump.emit()
	if event.is_action_released("ui_accept"):
		jump_released.emit()
	if event.is_action_pressed("dash"):
		dash.emit()
	if event.is_action_pressed("invert_gravity"):
		invert_gravity.emit()
		

func handle_move_input(_delta: float):
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction != last_direction:
		last_direction = direction
		move_command.emit(direction)
