extends StaticBody2D

const DISAPPEAR_DELAY: float = 3.0
const DISSOLVE_DURATION: float = 1.2

@onready var _label: Label = $Label
@onready var _color_rect: ColorRect = $ColorRect

var _counting: bool = false
var _elapsed: float = 0.0
var _dissolving: bool = false
var _dissolve_progress: float = 0.0

func _process(delta: float) -> void:
	if _dissolving:
		_dissolve_progress += delta / DISSOLVE_DURATION
		var amount = clamp(_dissolve_progress, 0.0, 1.0)
		(_color_rect.material as ShaderMaterial).set_shader_parameter("dissolve_amount", amount)
		(_label.material as ShaderMaterial).set_shader_parameter("dissolve_amount", amount)
		if _dissolve_progress >= 1.0:
			queue_free()
	elif _counting:
		_elapsed += delta
		if _elapsed >= DISAPPEAR_DELAY:
			_dissolving = true

func receive_uv_params(active: bool, light_pos: Vector2, facing: Vector2, cone_range: float, cone_half_angle: float) -> void:
	var mat := _label.material as ShaderMaterial
	mat.set_shader_parameter("uv_active", active)
	mat.set_shader_parameter("light_world_pos", light_pos)
	mat.set_shader_parameter("light_facing", facing)

	if not _counting and active and _all_corners_in_cone(light_pos, facing, cone_range, cone_half_angle):
		_counting = true

func _all_corners_in_cone(light_pos: Vector2, facing: Vector2, cone_range: float, cone_half_angle: float) -> bool:
	var corners := [
		Vector2(_label.offset_left, _label.offset_top),
		Vector2(_label.offset_right, _label.offset_top),
		Vector2(_label.offset_left, _label.offset_bottom),
		Vector2(_label.offset_right, _label.offset_bottom),
	]
	for corner in corners:
		var to_corner = (global_position + corner) - light_pos
		var dist = to_corner.length()
		if dist <= 0.0 or dist >= cone_range:
			return false
		if abs(facing.angle_to(to_corner.normalized())) >= cone_half_angle:
			return false
	return true
