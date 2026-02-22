extends Control

@onready var image_display: TextureRect = $ImageDisplay
@onready var cycle_button: Button = $Button
@onready var party_flash: ColorRect = $PartyFlash
@onready var confetti: CPUParticles2D = $Confetti

var party_colors = [
	Color(1, 0, 0, 0.25),
	Color(1, 0.4, 0, 0.25),
	Color(1, 1, 0, 0.25),
	Color(0, 1, 0, 0.25),
	Color(0, 1, 1, 0.25),
	Color(0, 0.3, 1, 0.25),
	Color(1, 0, 1, 0.25),
	Color(1, 0, 0.4, 0.25),
]
var color_index = 0
var flash_timer = 0.0
var flash_interval = 0.12
var party_active = false

var dvd_velocity = Vector2(160, 110)
var dvd_active = false

func _ready():
	cycle_button.pressed.connect(_on_button_pressed)
	var gradient = Gradient.new()
	gradient.colors = [Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.CYAN, Color.BLUE, Color.MAGENTA, Color.PINK]
	confetti.color_ramp = gradient

func _process(delta):
	if not party_active:
		return

	flash_timer += delta
	if flash_timer >= flash_interval:
		flash_timer = 0.0
		color_index = (color_index + 1) % party_colors.size()
		party_flash.color = party_colors[color_index]

	if dvd_active:
		image_display.position += dvd_velocity * delta
		var screen_size = size
		var img_size = image_display.size

		if image_display.position.x <= 0:
			image_display.position.x = 0
			dvd_velocity.x = abs(dvd_velocity.x)
		elif image_display.position.x + img_size.x >= screen_size.x:
			image_display.position.x = screen_size.x - img_size.x
			dvd_velocity.x = -abs(dvd_velocity.x)

		if image_display.position.y <= 0:
			image_display.position.y = 0
			dvd_velocity.y = abs(dvd_velocity.y)
		elif image_display.position.y + img_size.y >= screen_size.y:
			image_display.position.y = screen_size.y - img_size.y
			dvd_velocity.y = -abs(dvd_velocity.y)

func _on_button_pressed():
	image_display.texture = load("res://Assets/a2.jpg")
	image_display.visible = true
	image_display.position = (size - image_display.size) / 2
	party_active = true
	party_flash.visible = true
	confetti.emitting = true
	cycle_button.visible = false
	dvd_active = true
	$Victory.play()
