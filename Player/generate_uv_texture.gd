@tool
extends EditorScript

const BOUNDS = 2000
const DOT_STEP = 80
const DOT_RADIUS = 2.0
const DOT_COLOR = Color(0.85, 0.85, 0.85, 1.0)
const SAVE_PATH = "res://Level/dot_grid.png"

func _run() -> void:
	var size = BOUNDS * 2
	var img = Image.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(Color.WHITE)
	var r = int(DOT_RADIUS)
	for x in range(0, size + DOT_STEP, DOT_STEP):
		for y in range(0, size + DOT_STEP, DOT_STEP):
			for dx in range(-r - 1, r + 2):
				for dy in range(-r - 1, r + 2):
					if dx * dx + dy * dy <= DOT_RADIUS * DOT_RADIUS:
						var px = x + dx
						var py = y + dy
						if px >= 0 and px < size and py >= 0 and py < size:
							img.set_pixel(px, py, DOT_COLOR)
	var absolute_path = ProjectSettings.globalize_path(SAVE_PATH)
	img.save_png(absolute_path)
	EditorInterface.get_resource_filesystem().scan()
	print("Dot grid texture saved to: ", absolute_path)
