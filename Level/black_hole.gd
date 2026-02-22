extends Area2D

var return_scene = "res://Level/test_overworld.tscn"

func _ready() -> void:
	body_entered.connect(_on_area_2d_body_entered)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		TransitionManager.transition_to(return_scene, "SpaceSpawnPoint")
