extends Node2D
var level_type = Enums.LEVEL_TYPE.SIDE_SCROLL
#
#@onready var inactive = preload("res://Graphics/RetroWindowsGUI/Windows_Ratio_Inactive.png")
#@onready var entered = preload("res://Graphics/RetroWindowsGUI/Windows_Ratio.png")
#@onready var selected = preload("res://Graphics/RetroWindowsGUI/Windows_Ratio_Selected.png")
#@onready var text = $Area2D/TextureRect
#var in_exit = false
#
#func _ready() -> void:
	#text.texture = inactive
#
#
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#print(body)
	#text.texture = entered
	#in_exit = true
#
#
#
#
#func _on_area_2d_body_exited(body: Node2D) -> void:
	#text.texture = inactive
	#in_exit = false
#
#func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("ui_accept") and in_exit:
		#text.texture = selected
		#TransitionManager.transition_to("res://Level/level1.tscn")
