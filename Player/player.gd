extends CharacterBody2D

class_name Player

@export var player_stats: PlayerStats

@onready var facing: Vector2 = Vector2.DOWN

var can_move: bool = true

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

	


func _physics_process(_delta: float) -> void:
	move_and_slide()
