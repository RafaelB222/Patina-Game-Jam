extends CanvasLayer

signal scene_transitioning()
signal transition_complete()

var is_transitioning: bool = false

func transition_to(new_scene_file_path: String):
	print_debug("Transitioning to scene: ", new_scene_file_path)
	is_transitioning = true
	scene_transitioning.emit()
	var transition_result = get_tree().change_scene_to_file(new_scene_file_path)
	if transition_result != OK:
		printerr("Transition to: ", new_scene_file_path, " failed ;_;")
		return

	await get_tree().tree_changed
	# Wait until the new scene is actually assigned as current_scene
	while get_tree().current_scene == null:
		await get_tree().process_frame
	print_debug("Tree changed")
	var new_scene = get_tree().current_scene
	if not new_scene.is_node_ready():
		await new_scene.ready
	print_debug("The new scene is now: ", new_scene)

	transition_complete.emit()

	# Brief cooldown before allowing new transitions (prevents infinite loops)
	await get_tree().create_timer(0.1).timeout
	is_transitioning = false
