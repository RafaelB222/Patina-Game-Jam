extends Node2D

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
	add_to_group("evidence_storage")

func store_evidence(evidence: Dictionary) -> void:
	var evidence_type: String = evidence["type"]
	var evidence_value = evidence["value"]
	
	stored_evidence[evidence_type]["owned"] = true
	stored_evidence[evidence_type]["value"] = evidence_value
