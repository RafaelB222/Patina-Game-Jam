extends Control

@onready var top_secret_sprite: TextureRect = $PanelContainer/Panel/VBoxContainer/TopSecretSprite
@onready var text_file_sprite: TextureRect = $PanelContainer/Panel/VBoxContainer/TextFileSprite

func _ready() -> void:
	EvidenceContainer.evidence_obtained.connect(_on_evidence_obtained)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory") and self.visible == false:
		self.visible = true
	else:
			if Input.is_action_just_pressed("inventory"):
				self.visible = false

func _on_evidence_obtained():
	print('OH SHIT YEAH CUNT THATS MAD')
	if EvidenceContainer.username_obtained == true:
		$ColorRect.queue_free()
	if EvidenceContainer.password_obtained == true:
		$ColorRect2.queue_free()
