extends Node

@export var player: CharacterBody2D
@export var input_component: Node

var active: bool = false
var move_direction: Vector2 = Vector2.ZERO
var is_dashing: bool = false

@onready var _dash_timer: Timer = Timer.new()
@onready var _dash_cooldown_timer: Timer = Timer.new()

func _ready() -> void:
	_dash_timer.one_shot = true
	_dash_timer.timeout.connect(_on_dash_end)
	add_child(_dash_timer)
	_dash_cooldown_timer.one_shot = true
	add_child(_dash_cooldown_timer)
	if input_component:
		input_component.move_command.connect(_on_move)
		input_component.dash.connect(_on_dash)

func _on_move(direction: Vector2) -> void:
	move_direction = direction

func _on_dash() -> void:
	if not active:
		return
	if not _dash_cooldown_timer.is_stopped() or is_dashing:
		return
	var dash_dir = move_direction if move_direction != Vector2.ZERO else player.facing
	is_dashing = true
	player.velocity = dash_dir.normalized() * player.player_stats.dash_speed * player.player_stats.move_speed
	_dash_timer.start(player.player_stats.dash_duration)
	_dash_cooldown_timer.start(player.player_stats.dash_cooldown)

func _on_dash_end() -> void:
	is_dashing = false

func _physics_process(delta: float) -> void:
	if not active:
		return
	var stats = player.player_stats
	if is_dashing:
		return
	if move_direction != Vector2.ZERO:
		player.velocity = player.velocity.move_toward(move_direction * stats.move_speed, stats.acceleration * delta)
		player.facing = _get_cardinal_direction(move_direction)
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, stats.friction * delta)

func _get_cardinal_direction(direction: Vector2) -> Vector2:
	if abs(direction.x) > abs(direction.y):
		return Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		return Vector2.DOWN if direction.y > 0 else Vector2.UP
