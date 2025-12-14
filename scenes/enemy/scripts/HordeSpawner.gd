extends Node

@export var virus_scene: PackedScene = preload("res://scenes/enemy/Virus.tscn")
@export var enemies_per_wave: int = 3
@export var wave_increase: int = 2
@export var spawn_delay: float = 0.4
@export var max_enemies_alive: int = 15

var current_wave: int = 1
var enemies_spawned: int = 0
var enemies_alive: int = 0
var can_spawn: bool = false
var spawning: bool = false

signal wave_started(wave_number: int)

func _ready():
	start_wave()

func start_wave():
	print("WAVE:", current_wave)
	enemies_spawned = 0
	enemies_alive = 0
	can_spawn = true
	spawning = true
	emit_signal("wave_started", current_wave)

func _process(delta):
	if spawning and can_spawn:
		if enemies_spawned < enemies_per_wave:
			spawn_enemy()
			enemies_spawned += 1
			can_spawn = false
			await get_tree().create_timer(spawn_delay).timeout
			can_spawn = true
		else:
			# Ya se generaron todos los enemigos de la oleada
			spawning = false

	# Cuando todos los enemigos mueren → siguiente oleada
	if enemies_alive == 0 and spawning == false:
		next_wave()

func spawn_enemy():
	if enemies_alive >= max_enemies_alive:
		return

	var virus = virus_scene.instantiate()

	# Posición fija de cámara (ya que tu cámara no se mueve)
	var cam := get_viewport().get_camera_2d()
	var cam_pos := cam.global_position

	# Tamaño de la pantalla (igual que el mapa)
	var screen_size := get_viewport().get_visible_rect().size

	# Distancia desde la pantalla para spawnear enemigos
	var margin := 400

	var half_w := screen_size.x / 2
	var half_h := screen_size.y / 2

	# Límites visibles de la cámara (en coordenadas globales)
	var left := cam_pos.x - half_w
	var right := cam_pos.x + half_w
	var top := cam_pos.y - half_h
	var bottom := cam_pos.y + half_h

	var side := randi() % 4
	var pos := Vector2.ZERO

	match side:
		0: # Arriba
			pos = Vector2(
				randf_range(left, right),
				top - margin
			)
		1: # Derecha
			pos = Vector2(
				right + margin,
				randf_range(top, bottom)
			)
		2: # Abajo
			pos = Vector2(
				randf_range(left, right),
				bottom + margin
			)
		3: # Izquierda
			pos = Vector2(
				left - margin,
				randf_range(top, bottom)
			)

	virus.global_position = pos
	get_parent().add_child(virus)

	enemies_alive += 1
	virus.connect("tree_exited", Callable(self, "_on_virus_died"))

func _on_virus_died():
	enemies_alive -= 1


func next_wave():
	current_wave += 1
	enemies_per_wave += wave_increase

	# Aumentar dificultad
	spawn_delay = max(spawn_delay * 0.95, 0.1)  # no bajar de 0.1
	max_enemies_alive += 1

	start_wave()
