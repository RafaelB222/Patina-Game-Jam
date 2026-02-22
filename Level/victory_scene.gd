extends Control
@onready var victory_music: AudioStreamPlayer = $Victory2
@onready var victory: AudioStreamPlayer = $Victory

func _on_victory_2_finished() -> void:
	victory.play()
