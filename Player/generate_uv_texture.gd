@tool
extends EditorScript

const RADIUS = 300
const ANGLE_DEG = 65.0
const SAVE_PATH = "res://Player/uv_light_cone.png"

func _run() -> void:
	var size = RADIUS * 2
	var img = Image.create(size, size, false, Image.FORMAT_RGBA8)
	var center = Vector2(size / 2.0, size / 2.0)
	var half_angle = deg_to_rad(ANGLE_DEG / 2.0)
	for y in range(size):
		for x in range(size):
			var offset = Vector2(x, y) - center
			var dist = offset.length()
			if dist > 0.0 and dist <= RADIUS and abs(offset.angle()) <= half_angle:
				var falloff = pow(1.0 - (dist / RADIUS), 0.5)
				img.set_pixel(x, y, Color(1, 1, 1, falloff))
	img.save_png(SAVE_PATH)
	print("UV cone texture saved to: ", SAVE_PATH)
