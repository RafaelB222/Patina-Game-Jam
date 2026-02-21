extends Control

# @onready grabs a reference to a node as soon as the scene is ready.
# The $ is shorthand for get_node(). So $IntroPanel means get_node("IntroPanel").
@onready var intro_panel: Control = $IntroPanel
@onready var intro_title: Label = $IntroPanel/IntroTitle
@onready var menu_panel: Control = $MenuPanel


func _ready() -> void:
	# Hide the menu and make everything start invisible.
	# We'll animate them in with a Tween.
	menu_panel.visible = false
	menu_panel.modulate.a = 0.0
	intro_title.modulate.a = 0.0
	intro_title.scale = Vector2(0.0, 0.0)
	# Wait one frame so the layout engine has calculated the label's size,
	# then set the pivot to the centre so it scales outward from the middle.
	await get_tree().process_frame
	intro_title.pivot_offset = intro_title.size / 2
	_play_intro()


func _play_intro() -> void:
	# A Tween lets you animate any property over time.
	# By default, tweens run steps sequentially (one after the other).
	var tween := create_tween()

	# Step 1: Fade the title IN and scale it UP at the same time.
	# tween.parallel() makes the next step run alongside the previous one.
	tween.tween_property(intro_title, "modulate:a", 1.0, 1.2) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(intro_title, "scale", Vector2(1.0, 1.0), 1.2) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	# Step 2: Hold on the title for a moment.
	tween.tween_interval(1.5)

	# Step 3: Fade the entire intro panel OUT.
	tween.tween_property(intro_panel, "modulate:a", 0.0, 0.8) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

	# Step 4: tween_callback lets you call a function at a specific point in the sequence.
	# Here we swap which panel is visible once the intro has faded out.
	tween.tween_callback(func():
		intro_panel.visible = false
		menu_panel.visible = true
	)

	# Step 5: Fade the menu IN.
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
