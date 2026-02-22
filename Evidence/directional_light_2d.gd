extends PointLight2D

@export var pulse_speed: float = 2.0
@export var energy_strength: float = 0.3
@export var scale_strength: float = 0.1

var _base_energy: float
var _base_texture_scale: float = 1


var _time: float = 0.0

func _ready():
	_base_energy = energy
	_base_texture_scale = texture_scale

func _process(delta):
	_time += delta * pulse_speed
	
	var wave = (sin(_time) + 1.0) * 0.5  # 0..1
	
	# Pulse brightness
	energy = _base_energy * (1.0 + (wave - 0.5) * 2.0 * energy_strength)
	
	# Pulse light radius/softness
	texture_scale = _base_texture_scale * (1.0 + (wave - 0.5) * 2.0 * scale_strength)
