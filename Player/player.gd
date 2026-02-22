extends CharacterBody2D

class_name Player

@export var player_stats: PlayerStats
@export var input_component: Node
@export var player_collision_shape: CollisionShape2D
@export var side_scroll_movement: Node
@export var top_down_movement: Node
@export var uv_light_offset: float = 25.0

@onready var facing: Vector2 = Vector2.DOWN
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _uv_light = $UVLight
@onready var _action_component: Area2D = $ActionComponent

@onready var death_audio: AudioStreamPlayer = $DeathAudio
@onready var rebirth_audio: AudioStreamPlayer = $RebirthAudio

var original_modulate: Color
var original_scale: Vector2

var evidence_held: Dictionary = {
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

var can_move: bool = true
var _facing_indicator: Sprite2D
var _uv_active: bool = false

func _ready() -> void:
	original_modulate = _sprite.modulate
	original_scale = _sprite.scale
	add_to_group("player")
	#_facing_indicator = AnimatedSprite2D.new()
	#_facing_indicator.texture = _sprite.texture
	#_facing_indicator.modulate = Color(1, 0, 0, 0.5)
	#_facing_indicator.region_enabled = true
	#add_child(_facing_indicator)
	input_component.activate_uv_light.connect(activate_uv_light)
	input_component.eat_evidence.connect(eat_evidence)
	_uv_light.texture = _create_uv_cone_texture(300, 65.0)
	_uv_light.rotation = facing.angle()

func _physics_process(_delta: float) -> void:
	_update_facing_indicator()
	_uv_light.rotation = facing.angle()
	_uv_light.position = facing.normalized() * uv_light_offset
	move_and_slide()

func _update_facing_indicator() -> void:
	#var tex_size = _sprite.texture.get_size()
	var cardinal = _get_cardinal_facing()
	if cardinal == Vector2.RIGHT:
		_sprite.flip_h = false
		#_facing_indicator.region_rect = Rect2(tex_size.x / 2.0, 0, tex_size.x / 2.0, tex_size.y)
		#_facing_indicator.position = Vector2(tex_size.x / 4.0, 0)
	elif cardinal == Vector2.LEFT:
		_sprite.flip_h = true
		#_facing_indicator.region_rect = Rect2(0, 0, tex_size.x / 2.0, tex_size.y)
		#_facing_indicator.position = Vector2(-tex_size.x / 4.0, 0)
	elif cardinal == Vector2.DOWN:
		pass
		#_facing_indicator.region_rect = Rect2(0, tex_size.y / 2.0, tex_size.x, tex_size.y / 2.0)
		#_facing_indicator.position = Vector2(0, tex_size.y / 4.0)
	elif cardinal == Vector2.UP:
		pass
		#_facing_indicator.region_rect = Rect2(0, 0, tex_size.x, tex_size.y / 2.0)
		#_facing_indicator.position = Vector2(0, -tex_size.y / 4.0)

func _get_cardinal_facing() -> Vector2:
	if abs(facing.x) >= abs(facing.y):
		return Vector2.RIGHT if facing.x >= 0 else Vector2.LEFT
	else:
		return Vector2.DOWN if facing.y > 0 else Vector2.UP

func activate_uv_light() -> void:
	_uv_active = !_uv_active
	_uv_light.set_active(_uv_active)

func _create_uv_cone_texture(radius: int, angle_deg: float) -> ImageTexture:
	var size = radius * 2
	var img = Image.create(size, size, false, Image.FORMAT_RGBA8)
	var center = Vector2(size / 2.0, size / 2.0)
	var half_angle = deg_to_rad(angle_deg / 2.0)
	for y in range(size):
		for x in range(size):
			var offset = Vector2(x, y) - center
			var dist = offset.length()
			if dist > 0.0 and dist <= radius and abs(offset.angle()) <= half_angle:
				var falloff = pow(1.0 - (dist / radius), 0.5)
				img.set_pixel(x, y, Color(1, 1, 1, falloff))
	return ImageTexture.create_from_image(img)

func eat_evidence() -> void:
	for evidence in _action_component.get_nearby_evidence():
		var type: String = evidence.evidence_type
		if evidence_held.has(type):
			evidence_held[type]["owned"] = true
			evidence_held[type]["value"] = evidence.evidence_value
			print("You obtained the: ", type, " evidence!!!! Evidence held is now: ", evidence_held)
		evidence.queue_free()

func die() -> void:
	##THIS NEEDS TO HAPPEN BEFORE TRANSITION
	death_audio.play()
	var tween = get_tree().create_tween()
	tween.tween_property(_sprite, "modulate", Color.RED, 1.0)
	tween.parallel().tween_property(_sprite, "scale", Vector2(), 1.0)
	#await get_tree().create_timer(1).timeout
	for key in evidence_held:
		evidence_held[key]["owned"] = false
		evidence_held[key]["value"] = null
	var level_container = get_tree().get_first_node_in_group("level_container")
	if level_container and level_container._current_level:
		TransitionManager.transition_to(level_container._current_level.scene_file_path)
		
	else:
		get_tree().reload_current_scene()
	tween.tween_property(_sprite, "modulate", original_modulate, 0.2)
	tween.parallel().tween_property(_sprite, "scale", original_scale, 0.2)
	await get_tree().create_timer(1).timeout
	rebirth_audio.play()

func setup_for_level_type(type: Enums.LEVEL_TYPE) -> void:
	match type:
		Enums.LEVEL_TYPE.SIDE_SCROLL:
			side_scroll_movement.active = true
			top_down_movement.active = false
			motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
		Enums.LEVEL_TYPE.TOP_DOWN:
			side_scroll_movement.active = false
			top_down_movement.active = true
			motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
			velocity = Vector2.ZERO
