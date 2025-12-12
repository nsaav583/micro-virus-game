extends CanvasLayer

@onready var label_wave  = $MarginContainer/HBoxContainer/LabelWave
@onready var label_lives = $MarginContainer/HBoxContainer/LabelLives

func _ready():
	print("HUD listo!")


func update_wave(wave_num: int):
	label_wave.text = "Oleada: " + str(wave_num)

func update_lives(lives: int):
	label_lives.text = "Vidas: " + str(lives)
