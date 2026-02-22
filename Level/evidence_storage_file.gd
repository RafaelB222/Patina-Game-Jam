extends Node2D

@onready var highlight = $Highlight
@onready var area2D: Area2D = $Area2D
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
	area2D.body_entered.connect(_on_area_2d_body_entered)
	area2D.body_exited.connect(_on_area_2d_body_exited)

func store_evidence(evidence: Dictionary) -> void:
	print("evidence received from the player is: ", evidence)
	for evidence_key in evidence:
		var evidence_piece: Dictionary = evidence[evidence_key]
		print("The current piece of evidence is: ", evidence_piece)
		if evidence_piece["owned"]:
			print("storing ", evidence_key)
			stored_evidence[evidence_key] = evidence_piece
	
	print("Stored evidence is now: ", stored_evidence)


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
		var evidence: Dictionary = player.evidence_held
		store_evidence(evidence)
		
