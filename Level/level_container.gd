extends Node

signal level_loaded(spawn_position: Vector2)

var _current_level: Node = null

func load_level(scene_path: String, spawn_id: String = "SpawnPoint") -> void:
	if _current_level != null:
		_current_level.queue_free()
		await _current_level.tree_exited
		_current_level = null

	var packed: PackedScene = load(scene_path)
	_current_level = packed.instantiate()
	add_child(_current_level)

	var spawn_point = _current_level.find_child(spawn_id, true, false)
	if spawn_point == null and spawn_id != "SpawnPoint":
		spawn_point = _current_level.find_child("SpawnPoint", true, false)
	var spawn_pos: Vector2 = spawn_point.global_position if spawn_point else Vector2.ZERO
	level_loaded.emit(spawn_pos)
