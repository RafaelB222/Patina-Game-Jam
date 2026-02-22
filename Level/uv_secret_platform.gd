extends StaticBody2D

const DISAPPEAR_DELAY: float = 3.0
const DISSOLVE_DURATION: float = 1.2

@onready var _label: Label = $Label
@onready var _color_rect: ColorRect = $ColorRect

var _corners_touched: Array[bool] = [false, false, false, false]

func _ready() -> void:
	_label.material = _label.material.duplicate()
	_color_rect.material = _color_rect.material.duplicate()
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
	for mat in [_label.material, _color_rect.material]:
		(mat as ShaderMaterial).set_shader_parameter("uv_active", active)
		(mat as ShaderMaterial).set_shader_parameter("light_world_pos", light_pos)
		(mat as ShaderMaterial).set_shader_parameter("light_facing", facing)

	if not _counting and active:
		_update_corners_touched(light_pos, facing, cone_range, cone_half_angle)
		if not _corners_touched.has(false):
			_counting = true

func _update_corners_touched(light_pos: Vector2, facing: Vector2, cone_range: float, cone_half_angle: float) -> void:
	var corners := [
		Vector2(_label.offset_left, _label.offset_top),
		Vector2(_label.offset_right, _label.offset_top),
		Vector2(_label.offset_left, _label.offset_bottom),
		Vector2(_label.offset_right, _label.offset_bottom),
	]
	for i in range(corners.size()):
		if _corners_touched[i]:
			continue
		var to_corner = (global_position + corners[i]) - light_pos
		var dist = to_corner.length()
		if dist > 0.0 and dist < cone_range:
			if abs(facing.angle_to(to_corner.normalized())) < cone_half_angle:
				_corners_touched[i] = true
