extends Node

var password: String 
var password_obtained: bool = false
var image: Image
var image_obtained: bool = false
var sound_clip: AudioStream 
var sound_clip_obtained: bool = false
var gps_coords: Vector2 
var gps_coords_obtained: bool = false


func all_evidence_obtained() ->  bool:
	if password_obtained and image_obtained and sound_clip_obtained and gps_coords_obtained:
		return true
	else:
		return false

func obtain_password(password: String) -> void:
	password_obtained = true

func obtain_image(image: Image) -> void:
	image_obtained = true
	
	
func obtain_sound_clip(clip: AudioStream) -> void:
	sound_clip_obtained = true

func obtain_gps_coords(coords: Vector2) -> void:
	gps_coords_obtained = true
	
	
func _process(delta: float) -> void:
	var game_won: bool = all_evidence_obtained()
	if game_won:
		print("congrats on winning!!")
