extends Evidence
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	super._ready()
	evidence_type = "image"
	evidence_value = sprite.texture
