extends Node2D

@export var level_center: Vector2 = Vector2.ZERO

func _ready() -> void:
	PhysicsManager.use_center_gravity = true
	
	PhysicsManager.level_center = level_center

func _exit_tree() -> void:
	PhysicsManager.use_center_gravity = false
