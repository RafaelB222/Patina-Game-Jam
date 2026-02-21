extends State

class_name EnemyFollow

@export var parent_entity: Node
@export var move_speed := 30
@export var follow_range: int
@export var animation_tree: AnimationTree
@onready var animation_state_machine = animation_tree.get("parameters/playback")

var player: CharacterBody2D
var attack_range: int
var last_direction: Vector2

signal follow_command(direction, speed)
signal follow_entered(state_name)

func _ready() -> void:
	pass

func Enter():
	print("Follow state entered.")
	player = get_tree().get_first_node_in_group("players")
	move_speed = parent_entity.follow_speed
	follow_range = parent_entity.follow_range
	attack_range = parent_entity.attack_range
	print_debug("wander state move speed = ", move_speed, " and follow range = ", follow_range, " and attack range = ", attack_range)


	# follow_range = 100
	# print_debug("parent had no stats when follow state entered.")
	follow_entered.emit("follow")
	


func Physics_Update(_delta: float):
	if player != null:
		var direction = player.global_position - parent_entity.global_position
		
		if direction.length() > attack_range and direction != last_direction:
			follow_command.emit(direction, move_speed)
			last_direction = direction

		
		if direction.length() > follow_range:
			Transitioned.emit(self, "wander")
		elif direction.length() < attack_range:
			Transitioned.emit(self, "attack")
