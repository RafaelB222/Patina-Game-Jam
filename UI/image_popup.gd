extends Control

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var timer: Timer = $Timer

func _ready() -> void:
	visible = false
	add_to_group("image_popup")
	timer.timeout.connect(_dismiss)

func show_evidence(texture: Texture2D, label_text: String) -> void:
	texture_rect.texture = texture
	label.text = label_text
	visible = true
	timer.start()

func _dismiss() -> void:
	visible = false
	timer.stop()

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey or event is InputEventMouseButton:
		if event.is_pressed():
			_dismiss()
			get_viewport().set_input_as_handled()
