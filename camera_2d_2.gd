extends Camera2D

func _ready() -> void:
	TransitionManager.camera_shake.connect(_on_camera_shake)


func _on_camera_shake():
	pass
