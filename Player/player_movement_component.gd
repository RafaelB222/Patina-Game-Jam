extends Node2D

@export var player: CharacterBody2D
@export var input_component: Node


var move_direction: Vector2 = Vector2.ZERO
var has_double_jump: bool = false
var has_air_dash: bool = false
var is_dashing: bool = false
var pre_dash_velocity_y: float = 0.0
var gravity_dir: float = 1.0
@onready var dash_timer: Timer = Timer.new()
#var jump_held: bool = false # Used by charge jump approach
#var jump_hold_timer: float = 0.0 # Used by charge jump approach
#var is_jumping: bool = false # Used by variable_jump_cut approach

func _ready() -> void:
	dash_timer.one_shot = true
	dash_timer.timeout.connect(dash_end)
	add_child(dash_timer)
	if input_component:
		input_component.move_command.connect(move)
		input_component.jump.connect(jump)
		input_component.jump_released.connect(jump_released)
		input_component.dash.connect(dash)
		input_component.invert_gravity.connect(invert_gravity)
	

func move(direction):
	move_direction = direction

func invert_gravity():
	gravity_dir *= -1.0
	player.up_direction.y *= -1.0

func dash():
	var on_floor = player.is_on_floor()
	if !dash_timer.is_stopped():
		return
	if !on_floor and !has_air_dash:
		return
	is_dashing = true
	pre_dash_velocity_y = player.velocity.y
	if !on_floor:
		has_air_dash = false
	var dash_dir = signf(player.facing.x) if player.facing.x != 0 else 1.0
	player.velocity.x = dash_dir * player.player_stats.dash_speed * player.player_stats.move_speed
	player.velocity.y = 0
	dash_timer.start(player.player_stats.dash_duration)

func dash_end():
	if is_dashing:
		is_dashing = false
		player.velocity.y = pre_dash_velocity_y
		dash_timer.start(player.player_stats.dash_cooldown)

	

## Variable jump cut approach (jump on press, cut velocity on release)
#func jump():
	#if player.is_on_floor():
		#player.velocity.y = player.player_stats.jump_velocity
		#is_jumping = true
#
#func jump_released():
	#if is_jumping and player.velocity.y < 0:
		#player.velocity.y *= player.player_stats.variable_jump_cut
		#is_jumping = false

## Charge jump approach (jump on release, height depends on hold duration)
#func jump():
	#if player.is_on_floor():
		#jump_held = true
		#jump_hold_timer = 0.0
#
#func jump_released():
	#if jump_held and player.is_on_floor():
		#var stats = player.player_stats
		#var t = clampf(jump_hold_timer / stats.max_jump_hold_time, 0.0, 1.0)
		#var height = lerpf(stats.min_jump_height, stats.jump_height, t)
		#player.velocity.y = -2.0 * height / stats.jump_time_to_peak
	#jump_held = false
	#jump_hold_timer = 0.0

## Double jump approach (jump on press, second jump available in air)
func jump():
	if player.is_on_floor():
		player.velocity.y = player.player_stats.jump_velocity * gravity_dir
		has_double_jump = true
	elif has_double_jump:
		player.velocity.y = -2.0 * player.player_stats.double_jump_height / player.player_stats.jump_time_to_peak * gravity_dir
		has_double_jump = false

func jump_released():
	pass

func get_cardinal_direction(direction: Vector2) -> Vector2:
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			return Vector2.RIGHT
		else:
			return Vector2.LEFT

	else:
		if direction.y > 0:
			return Vector2.DOWN
		else: 
			return Vector2.UP
func apply_gravity(delta: float) -> void:
	if not player.is_on_floor():
		var is_falling = player.velocity.y * gravity_dir > 0
		var gravity = player.player_stats.fall_gravity if is_falling else player.player_stats.jump_gravity
		player.velocity.y += gravity * gravity_dir * delta
		player.velocity.y = clampf(player.velocity.y, -player.player_stats.max_fall_speed, player.player_stats.max_fall_speed)

func _physics_process(delta: float) -> void:
	if player.is_on_floor():
		has_double_jump = true
		has_air_dash = true
	if !is_dashing:
		apply_gravity(delta)
	if player.can_move:
		var stats = player.player_stats
		var on_floor = player.is_on_floor()
		var accel = stats.acceleration if on_floor else stats.air_acceleration
		var decel = stats.friction if on_floor else stats.air_friction

		if move_direction.x != 0:
			player.velocity.x = move_toward(player.velocity.x, move_direction.x * stats.move_speed, accel * delta)
			player.facing = get_cardinal_direction(move_direction)
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, decel * delta)

	
