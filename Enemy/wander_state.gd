extends State

class_name EnemyWander

@export var parent_entity: Node
@export var move_speed := 10.0
@export var follow_range: int
@export var animation_tree: AnimationTree
@onready var animation_state_machine = animation_tree.get("parameters/playback") if animation_tree else null

var player: CharacterBody2D

var move_direction : Vector2
var wander_time : float
var last_direction: Vector2

signal wander_command(direction, speed)
signal wander_entered(state_name)

func _ready() -> void:
	pass

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)
	# parent_entity.move_direction = move_direction
	if move_direction != last_direction:
		wander_command.emit(move_direction, move_speed)
		last_direction = move_direction


func Enter():
	print("Wander state entered.")
	player = get_tree().get_first_node_in_group("player")
	move_speed = parent_entity.wander_speed
	follow_range = parent_entity.follow_range
	print_debug("wander state move speed = ", move_speed, " and follow range = ", follow_range)
	# print_debug("parent had no stats when wander state entered.")
	randomize_wander()
	wander_entered.emit("wander")

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	
	else:
		randomize_wander()


func Physics_Update(_delta: float):
	if parent_entity == null:
		print_debug("parent entity is null")
		return
	if player == null:
		print_debug("player is null")
		return

	var direction = player.global_position - parent_entity.global_position
	
	if direction.length() < follow_range:
		Transitioned.emit(self, "follow")
	
