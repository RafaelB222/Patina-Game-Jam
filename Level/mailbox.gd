extends Control

var level_type = Enums.LEVEL_TYPE.SIDE_SCROLL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().current_scene == self:
		var player = preload("res://Player/player.tscn")
		var player_instance = player.instantiate()
		var spawn_point = find_child("SpawnPoint", true, false)
		if spawn_point:
			player_instance.global_position = spawn_point.global_position
		add_child(player_instance)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
