extends Node

@onready var player: CharacterBody2D = $SubViewportContainer/SubViewport/Player
@onready var level_container = $SubViewportContainer/SubViewport/LevelContainer

func _ready() -> void:
	level_container.level_loaded.connect(_on_level_loaded)
	level_container.load_level("res://Level/level_tutorial.tscn")

func _on_level_loaded(spawn_position: Vector2) -> void:
	player.global_position = spawn_position
	var current_level = level_container._current_level
	if current_level and "level_type" in current_level:
		player.setup_for_level_type(current_level.level_type)
