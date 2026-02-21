extends ColorRect


func _ready() -> void:
	size = get_viewport_rect().size
	material.set_shader_parameter("tex", $"../SubViewport".get_texture())
