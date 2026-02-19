extends CharacterBody2D

class_name Player

@export var player_stats: PlayerStats

@onready var facing: Vector2 = Vector2.DOWN
@onready var _sprite: Sprite2D = $Sprite2D

var can_move: bool = true
var _facing_indicator: Sprite2D

func _ready() -> void:
	_facing_indicator = Sprite2D.new()
	_facing_indicator.texture = _sprite.texture
	_facing_indicator.modulate = Color(1, 0, 0, 0.5)
	_facing_indicator.region_enabled = true
	add_child(_facing_indicator)

func _physics_process(_delta: float) -> void:
	_update_facing_indicator()
	move_and_slide()

func _update_facing_indicator() -> void:
	var tex_size = _sprite.texture.get_size()
	var cardinal = _get_cardinal_facing()
	if cardinal == Vector2.RIGHT:
		_facing_indicator.region_rect = Rect2(tex_size.x / 2.0, 0, tex_size.x / 2.0, tex_size.y)
		_facing_indicator.position = Vector2(tex_size.x / 4.0, 0)
	elif cardinal == Vector2.LEFT:
		_facing_indicator.region_rect = Rect2(0, 0, tex_size.x / 2.0, tex_size.y)
		_facing_indicator.position = Vector2(-tex_size.x / 4.0, 0)
	elif cardinal == Vector2.DOWN:
		_facing_indicator.region_rect = Rect2(0, tex_size.y / 2.0, tex_size.x, tex_size.y / 2.0)
		_facing_indicator.position = Vector2(0, tex_size.y / 4.0)
	elif cardinal == Vector2.UP:
		_facing_indicator.region_rect = Rect2(0, 0, tex_size.x, tex_size.y / 2.0)
		_facing_indicator.position = Vector2(0, -tex_size.y / 4.0)

func _get_cardinal_facing() -> Vector2:
	if abs(facing.x) >= abs(facing.y):
		return Vector2.RIGHT if facing.x >= 0 else Vector2.LEFT
	else:
		return Vector2.DOWN if facing.y > 0 else Vector2.UP
