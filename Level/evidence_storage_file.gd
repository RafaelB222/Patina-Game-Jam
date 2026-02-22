extends Node2D

@onready var highlight = $Highlight
@onready var area2D: Area2D = $Area2D
var player_in_range: bool = false
var player: CharacterBody2D
var path_to_victory: String = "res://Level/victory_scene.tscn"



var stored_evidence: Dictionary = {
	"password": {
		"owned": false,
		"value": null
	},
	"image": {
		"owned": false,
		"value": null
	},
	"sound_clip": {
		"owned": false,
		"value": null
	},
	"gps_coords": {
		"owned": false,
		"value": null
	}
}

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	add_to_group("evidence_storage")
	area2D.body_entered.connect(_on_area_2d_body_entered)
	area2D.body_exited.connect(_on_area_2d_body_exited)



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		highlight.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		highlight.visible = false

func check_evidence() -> bool:
	if EvidenceContainer.password_obtained and EvidenceContainer.username_obtained:
		print("YOU WIN!!!!!!")
		return true
	else:
		print("NOT ENOUGH EVIDENCE NOOB!!!!")
		return false


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range:
		if check_evidence():
			TransitionManager.transition_to(path_to_victory)
		else:
			var popup = get_tree().get_first_node_in_group("image_popup")
			if popup:
				if not EvidenceContainer.username_obtained and not EvidenceContainer.password_obtained:
					popup.show_evidence(null, "Missing Username and Password!")
				elif not EvidenceContainer.username_obtained:
					popup.show_evidence(null, "Missing Username!")
				elif not EvidenceContainer.password_obtained:
					popup.show_evidence(null, "Missing Password!")
		
