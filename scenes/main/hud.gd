extends CanvasLayer

@onready var label_wave  = $MarginContainer/HUDPanel/VBoxContainer/WaveBox/LabelWave
@onready var label_lives = $MarginContainer/HUDPanel/VBoxContainer/LivesBox/LabelLives
@onready var health_bar  = $MarginContainer/HUDPanel/VBoxContainer/HealthBar


func _ready():
	print("HUD listo!")
	print("LabelLives:", label_lives)
	print("HealthBar:", health_bar)

	var spawner = get_tree().current_scene.get_node_or_null("HordeSpawner")
	if spawner:
		spawner.wave_started.connect(update_wave)


func update_wave(wave_num: int):
	label_wave.text = "Oleada: " + str(wave_num)

func update_lives(lives: int):
	label_lives.text = "Vidas: " + str(lives)
	health_bar.value = lives
