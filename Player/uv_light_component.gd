extends PointLight2D

class_name UVLightComponent

const UV_RANGE: float = 300.0
const UV_HALF_ANGLE: float = deg_to_rad(32.5)

@onready var _cone_area: Area2D = $ConeArea

var _in_range: Array = []

func _ready() -> void:
	_cone_area.monitoring = false
	_cone_area.body_entered.connect(_on_body_entered)
	_cone_area.body_exited.connect(_on_body_exited)

func set_active(active: bool) -> void:
	if not active:
		for body in _in_range:
			if is_instance_valid(body) and body.has_method("receive_uv_params"):
				body.receive_uv_params(false, global_position, get_parent().facing, UV_RANGE, UV_HALF_ANGLE)
		_in_range.clear()
	enabled = active
	_cone_area.monitoring = active

func _physics_process(_delta: float) -> void:
	if not enabled:
		return
	var player_facing: Vector2 = get_parent().facing
	for body in _in_range:
		if is_instance_valid(body) and body.has_method("receive_uv_params"):
			body.receive_uv_params(true, global_position, player_facing, UV_RANGE, UV_HALF_ANGLE)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("receive_uv_params") and body not in _in_range:
		_in_range.append(body)

func _on_body_exited(body: Node2D) -> void:
	_in_range.erase(body)
	if is_instance_valid(body) and body.has_method("receive_uv_params"):
		body.receive_uv_params(false, global_position, get_parent().facing, UV_RANGE, UV_HALF_ANGLE)
