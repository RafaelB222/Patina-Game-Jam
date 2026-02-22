extends Evidence

@export var username: String = "m.hurley@nasa.gov"

func _ready() -> void:
	super._ready()
	evidence_type = "username"
	evidence_value = username
	EvidenceContainer.username_discovered = true
