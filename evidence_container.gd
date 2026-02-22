extends Node

var username: String
var username_discovered: bool = false
var username_obtained: bool = false
var password: String
var password_obtained: bool = false

signal evidence_obtained()


#func all_evidence_obtained() ->  bool:
	#if password_obtained and image_obtained and sound_clip_obtained and gps_coords_obtained:
		#return true
	#else:
		#return false


func obtain_password(obtained_password: String) -> void:
	password = obtained_password
	password_obtained = true
	evidence_obtained.emit()

func obtain_username(obtained_username: String) ->  void:
	username = obtained_username
	username_obtained = true
	evidence_obtained.emit()
