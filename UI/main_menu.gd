extends Control

# @onready grabs a reference to a node as soon as the scene is ready.
# The $ is shorthand for get_node(). So $IntroPanel means get_node("IntroPanel").
@onready var intro_panel: Control = $IntroPanel
@onready var intro_video: VideoStreamPlayer = $IntroPanel/VideoStreamPlayer
@onready var menu_panel: Control = $MenuPanel


func _ready() -> void:
	# Hide the menu at the start — we'll fade it in after the video.
	menu_panel.visible = false
	menu_panel.modulate.a = 0.0
	# .connect() links a signal to a function.
	# "finished" fires automatically when the video reaches the end.
	intro_video.finished.connect(_on_intro_finished)


func _on_intro_finished() -> void:
	# This runs as soon as the video ends.
	var tween := create_tween()

	# Fade the entire intro panel out.
	tween.tween_property(intro_panel, "modulate:a", 0.0, 0.8) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

	# Once faded, swap which panel is visible.
	# tween_callback lets you call a function at a specific point in the sequence.
	tween.tween_callback(func():
		intro_panel.visible = false
		menu_panel.visible = true
	)

	# Fade the menu in.
	tween.tween_property(menu_panel, "modulate:a", 1.0, 0.6) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


# These functions are called by button signals (see the [connection] lines in the .tscn).
# When a button emits its "pressed" signal, Godot calls the connected function.

func _on_new_game_pressed() -> void:
	# change_scene_to_file swaps the entire scene tree to a new scene.
	get_tree().change_scene_to_file("res://game_container.tscn")


func _on_load_game_pressed() -> void:
	# TODO: implement a save/load system
	print("Load game - not yet implemented")


func _on_settings_pressed() -> void:
	# TODO: implement a settings panel
	print("Settings - not yet implemented")
