extends Node

@export var entity: CharacterBody2D
@export var wander_state: EnemyWander
@export var follow_state: EnemyFollow

var _target_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	if wander_state:
		wander_state.wander_command.connect(_on_wander_command)
	if follow_state:
		follow_state.follow_command.connect(_on_follow_command)

func _on_wander_command(direction: Vector2, speed: float) -> void:
	_target_velocity = direction.normalized() * speed

func _on_follow_command(direction: Vector2, speed: float) -> void:
	_target_velocity = direction.normalized() * speed

func _physics_process(_delta: float) -> void:
	if entity:
		entity.velocity = _target_velocity
