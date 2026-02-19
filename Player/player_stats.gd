extends Resource

class_name PlayerStats

## Movement
@export var move_speed: float = 300.0
@export var acceleration: float = 1500.0
@export var friction: float = 1200.0
@export var air_acceleration: float = 800.0
@export var air_friction: float = 200.0
@export var dash_speed: float = 3.0
@export var dash_duration: float = 0.25
@export var dash_cooldown: float = 0.0

## Jumping
@export var jump_height: float = 120.0
@export var jump_time_to_peak: float = 0.4
@export var jump_time_to_fall: float = 0.35
@export var max_fall_speed: float = 800.0

## Jump tuning
@export var coyote_time: float = 0.12 # gives a brief window for the player to jump after stepping off a platform.
@export var jump_buffer_time: float = 0.1 # Registers a jump command slightly before landing.
@export var variable_jump_cut: float = 0.5 # Allows the player to tap jump for a smaller jump.
@export var min_jump_height: float = 30.0 # Minimum jump height on a quick tap.
@export var max_jump_hold_time: float = 0.3 # How long the player must hold jump for a full height jump.
@export var double_jump_height: float = 80.0 # Height of the second jump.

## Derived jump physics (calculated from height and time)
var jump_velocity: float:
	get: return -2.0 * jump_height / jump_time_to_peak
var jump_gravity: float:
	get: return 2.0 * jump_height / (jump_time_to_peak * jump_time_to_peak)
var fall_gravity: float:
	get: return 2.0 * jump_height / (jump_time_to_fall * jump_time_to_fall)
