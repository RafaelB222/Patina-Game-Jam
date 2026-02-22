extends CharacterBody2D

class_name Antivirus

@export var wander_speed: float = 80.0
@export var follow_speed: float = 150.0
@export var follow_range: int = 300
@export var attack_range: int = 50

@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer
@onready var audio_listener_2d: AudioListener2D = $AudioListener2D


var initial_behavior_state: String = "wander"

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	audio_listener_2d.make_current()

func _physics_process(_delta: float) -> void:
	move_and_slide()


func _on_audio_stream_player_finished() -> void:
	audio_stream_player.play()
