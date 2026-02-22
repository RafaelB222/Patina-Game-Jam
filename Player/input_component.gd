extends Node

signal move_command(direction)
signal basic_attack
signal jump
signal jump_released
signal dash
signal invert_gravity
signal activate_uv_light
signal eat_evidence

var last_direction: Vector2 = Vector2.ZERO

@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var audio_stream_player_2: AudioStreamPlayer = $"../AudioStreamPlayer2"
@onready var dash_audio: AudioStreamPlayer = $"../DashAudio"

func _process(delta: float) -> void:
	handle_move_input(delta)

func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("left_click"):
		#basic_attack.emit()
	
	if event.is_action_pressed("jump"):
		jump.emit()
		audio_stream_player.play()
		audio_stream_player_2.play()
	if event.is_action_released("jump"):
		jump_released.emit()
	if event.is_action_pressed("dash"):
		dash.emit()
		dash_audio.play()
	if event.is_action_pressed("UVlight"):
		activate_uv_light.emit()
	if event.is_action_pressed("eat_evidence"):
		eat_evidence.emit()

func handle_move_input(_delta: float):
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction != last_direction:
		last_direction = direction
		move_command.emit(direction)
