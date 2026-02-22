extends CanvasLayer

signal scene_transitioning()
signal transition_complete()

signal camera_shake()

var is_transitioning: bool = false

func transition_to(new_scene_file_path: String, spawn_id: String = "SpawnPoint") -> void:
	if is_transitioning:
		return
	print_debug("Transitioning to scene: ", new_scene_file_path)
	is_transitioning = true
	scene_transitioning.emit()

	var level_container = get_tree().get_first_node_in_group("level_container")
	if level_container == null:
		printerr("TransitionManager: Could not find node in group 'level_container'.")
		is_transitioning = false
		return

	await level_container.load_level(new_scene_file_path, spawn_id)

	transition_complete.emit()
	await get_tree().create_timer(0.1).timeout
	is_transitioning = false
