extends Node

var use_center_gravity: bool = false
var level_center: Vector2 = Vector2.ZERO
var gravity_direction: Vector2 = Vector2.DOWN

func get_gravity_dir(world_pos: Vector2) -> Vector2:
	if use_center_gravity:
		var to_center = level_center - world_pos
		if to_center.length_squared() < 1.0:
			return gravity_direction
		return to_center.normalized()
	return gravity_direction

func invert_gravity() -> void:
	gravity_direction *= -1.0
