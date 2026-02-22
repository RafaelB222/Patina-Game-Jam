extends Area2D

class_name Evidence

var evidence_type: String
var evidence_value

func _ready() -> void:
	add_to_group("evidence")



func collect() -> void:
	queue_free()
	
