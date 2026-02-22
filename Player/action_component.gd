extends Area2D

func get_nearby_evidence() -> Array:
	var result = []
	for area in get_overlapping_areas():
		if area.is_in_group("evidence"):
			result.append(area)
	return result
