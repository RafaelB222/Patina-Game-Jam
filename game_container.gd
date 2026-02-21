extends Node

@onready var player: CharacterBody2D = $Player
@onready var level_container = $LevelContainer

func _ready() -> void:
	level_container.level_loaded.connect(_on_level_loaded)
	level_container.load_level("res://Level/level_tutorial.tscn")

func _on_level_loaded(spawn_position: Vector2) -> void:
	player.global_position = spawn_position
