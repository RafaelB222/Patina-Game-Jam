extends Node2D

var level_type = Enums.LEVEL_TYPE.TOP_DOWN

const BOUNDS = 2000
const DOT_STEP = 80
const DOT_RADIUS = 2.0
const DOT_COLOR = Color(0.85, 0.85, 0.85, 1.0)

func _ready() -> void:
	queue_redraw()
	if get_tree().current_scene == self:
		var player = preload("res://Player/player.tscn").instantiate()
		var spawn_point = find_child("SpawnPoint", true, false)
		if spawn_point:
			player.global_position = spawn_point.global_position
		add_child(player)
		player.setup_for_level_type(level_type)

func _draw() -> void:
	draw_rect(Rect2(-BOUNDS, -BOUNDS, BOUNDS * 2, BOUNDS * 2), Color.WHITE)
	for x in range(-BOUNDS, BOUNDS + DOT_STEP, DOT_STEP):
		for y in range(-BOUNDS, BOUNDS + DOT_STEP, DOT_STEP):
			draw_circle(Vector2(x, y), DOT_RADIUS, DOT_COLOR)
