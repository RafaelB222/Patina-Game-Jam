extends Node2D

@onready var highlight = $Highlight
var player_in_range: bool = false
var player: CharacterBody2D


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
	body_entered.connect(_on_area_2d_body_entered)
	body_exited.connect(_on_area_2d_body_exited)

func store_evidence(evidence: Dictionary) -> void:
	var evidence_type: String = evidence["type"]
	var evidence_value = evidence["value"]
	
	stored_evidence[evidence_type]["owned"] = true
	stored_evidence[evidence_type]["value"] = evidence_value


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		highlight.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		highlight.visible = false


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range:
		
