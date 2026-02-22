extends CanvasLayer

signal scene_transitioning()
signal transition_complete()
signal camera_shake()

const FADE_DURATION: float = 0.4

var is_transitioning: bool = false
var _fade_rect: ColorRect

func _ready() -> void:
	_fade_rect = ColorRect.new()
	_fade_rect.color = Color.BLACK
	_fade_rect.modulate.a = 0.0
	_fade_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_fade_rect)

func transition_to(new_scene_file_path: String, spawn_id: String = "SpawnPoint") -> void:
	if is_transitioning:
		return
	print_debug("Transitioning to scene: ", new_scene_file_path)
	is_transitioning = true
	scene_transitioning.emit()

	var fade_in := create_tween()
	fade_in.tween_property(_fade_rect, "modulate:a", 1.0, FADE_DURATION)
	await fade_in.finished

	var level_container = get_tree().get_first_node_in_group("level_container")
	if level_container == null:
		printerr("TransitionManager: Could not find node in group 'level_container'.")
		is_transitioning = false
		_fade_rect.modulate.a = 0.0
		return

	await level_container.load_level(new_scene_file_path, spawn_id)

	transition_complete.emit()

	var fade_out := create_tween()
	fade_out.tween_property(_fade_rect, "modulate:a", 0.0, FADE_DURATION)
	await fade_out.finished

	is_transitioning = false
