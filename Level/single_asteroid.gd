extends StaticBody2D

@onready var asteroid_sprite = $Sprite2D

const CO_ASTERIODS = preload("uid://cvw0plglsbqn0")
const DESTROYED_ASTERIOD_1 = preload("uid://ccebrmav332w")
const LARGE_ASTERIOD_2 = preload("uid://cefvit07xic2b")
const LARGE_ASTERIOD = preload("uid://cqjce7gyr1rwd")
const MEDIUM_ASTERIOD_1 = preload("uid://b6lxx6vrcocyl")
const MEDIUM_ASTERIOD_2 = preload("uid://rrbddhc5ri6l")
const SMALL_ASTERIOD_1 = preload("uid://chj0ivx35pc86")
const SMALL_ASTERIOD_2 = preload("uid://tocq75cpfa6b")
const SMALL_ASTERIOD_3 = preload("uid://cd2ycdks5r1nv")


var potential_sprites = [
	 preload("uid://cvw0plglsbqn0"),
	 preload("uid://ccebrmav332w"),
	 preload("uid://cefvit07xic2b"),
	 preload("uid://cqjce7gyr1rwd"),
	 preload("uid://b6lxx6vrcocyl"),
	 preload("uid://rrbddhc5ri6l"),
	 preload("uid://bxor7w6f8ak6o"),
	 preload("uid://chj0ivx35pc86"),
	 preload("uid://tocq75cpfa6b"),
	 preload("uid://cd2ycdks5r1nv")
]

func _ready() -> void:
	asteroid_sprite.texture = potential_sprites[randi()%potential_sprites.size()]
