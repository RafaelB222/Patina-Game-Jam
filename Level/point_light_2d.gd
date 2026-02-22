extends PointLight2D

@export var flicker_speed: float = 10.0
@export var energy_min: float = 0.8
@export var energy_max: float = 1.2
@export var scale_flicker: float = 0.05  # subtle size breathing

var _base_energy: float
var _base_scale: Vector2
var _target_energy: float
var _target_scale: Vector2

func _ready():
	_base_energy = energy
	_base_scale = texture_scale * Vector2.ONE
	_target_energy = _base_energy
	_target_scale = _base_scale

func _process(delta):
	if randf() < flicker_speed * delta:
		_target_energy = _base_energy * randf_range(energy_min, energy_max)
		_target_scale = _base_scale * randf_range(1.0 - scale_flicker, 1.0 + scale_flicker)

	energy = lerp(energy, _target_energy, delta * flicker_speed)
	texture_scale = lerp(texture_scale, _target_scale.x, delta * flicker_speed)
