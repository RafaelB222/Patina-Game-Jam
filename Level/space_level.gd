extends Node2D

@export var level_center: Vector2 = Vector2.ZERO
var level_type = Enums.LEVEL_TYPE.SIDE_SCROLL

func _ready() -> void:
	PhysicsManager.use_center_gravity = true
	PhysicsManager.level_center = level_center

	if get_tree().current_scene == self:
		var player = preload("res://Player/player.tscn").instantiate()
		var spawn_point = find_child("SpawnPoint", true, false)
		if spawn_point:
			player.global_position = spawn_point.global_position
		add_child(player)
func _exit_tree() -> void:
	PhysicsManager.use_center_gravity = false
