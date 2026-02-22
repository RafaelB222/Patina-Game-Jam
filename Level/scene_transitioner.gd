extends Area2D

@onready var inactive = preload("res://Graphics/RetroWindowsGUI/Windows_Ratio_Inactive.png")
@onready var entered = preload("res://Graphics/RetroWindowsGUI/Windows_Ratio.png")
@onready var selected = preload("res://Graphics/RetroWindowsGUI/Windows_Ratio_Selected.png")
@onready var text = $TextureRect
@onready var highlight = $Highlight
@onready var label = $Label
@onready var sound = $AudioPlaya2D

@export_file("*.tscn") var next_scene: String
@export var texture: Texture2D
@export var label_text: String = ""

var in_exit = false

func _ready() -> void:
	monitoring = false
	body_entered.connect(_on_area_2d_body_entered)
	body_exited.connect(_on_area_2d_body_exited)
	await get_tree().physics_frame
	monitoring = true
	if texture:
		text.texture = texture
		text.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		text.stretch_mode = TextureRect.STRETCH_SCALE
		var half = texture.get_size()
		text.offset_left = -half.x
		text.offset_top = -half.y
		text.offset_right = half.x
		text.offset_bottom = half.y
		highlight.offset_left = -half.x - 4.0
		highlight.offset_top = -half.y - 4.0
		highlight.offset_right = half.x + 4.0
		highlight.offset_bottom = half.y + 4.0
		label.offset_top = half.y + 4.0
		label.offset_bottom = half.y + 18.0
	else:
		text.texture = inactive
	if label_text:
		label.text = label_text
		label.visible = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_exit = true
		if texture:
			highlight.visible = true
		else:
			text.texture = entered


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_exit = false
		if texture:
			highlight.visible = false
		else:
			text.texture = inactive


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and in_exit:
		sound.play()
		if not texture:
			text.texture = selected
		await get_tree().create_timer(.5).timeout
		TransitionManager.transition_to(next_scene)
