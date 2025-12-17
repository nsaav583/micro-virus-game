extends CharacterBody2D

@export var bullet_scene: PackedScene = preload("res://scenes/player/Bullet.tscn")
@export var shoot_cooldown: float = 0.2
var shoot_timer: float = 0.0

@onready var gun_pos = $GunPosition

@export var speed: float = 260.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hud = get_tree().current_scene.get_node_or_null("HUD")
var last_direction: Vector2 = Vector2.DOWN

func _ready():
	if hud:
		hud.call_deferred("update_lives", health)

func _physics_process(delta):
	# POSICIÓN DEL PUNTO DE DISPARO (apunta delante del jugador)
	gun_pos.position = last_direction * 10

	# INPUT DE MOVIMIENTO
	var input_vector := Vector2.ZERO
	input_vector.y -= Input.get_action_strength("move_up")
	input_vector.y += Input.get_action_strength("move_down")
	input_vector.x -= Input.get_action_strength("move_left")
	input_vector.x += Input.get_action_strength("move_right")

	# SI HAY INPUT → guardar dirección
	if input_vector != Vector2.ZERO:
		last_direction = input_vector
		input_vector = input_vector.normalized()

	# MOVIMIENTO
	velocity = input_vector * speed
	move_and_slide()

	# ANIMACIONES
	if input_vector != Vector2.ZERO:
		_update_animation(last_direction)

	# SISTEMA DE DISPARO
	shoot_timer -= delta
	if Input.is_action_pressed("shoot") and shoot_timer <= 0:
		shoot()
		shoot_timer = shoot_cooldown


func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = gun_pos.global_position
	bullet.direction = last_direction.normalized()
	get_parent().add_child(bullet)


func _update_animation(dir: Vector2):
	if dir.x == 0 and dir.y < 0:
		anim.play("up")
	elif dir.x == 0 and dir.y > 0:
		anim.play("down")
	elif dir.x < 0 and dir.y == 0:
		anim.play("left")
	elif dir.x > 0 and dir.y == 0:
		anim.play("right")
	elif dir.x < 0 and dir.y < 0:
		anim.play("up_left")
	elif dir.x > 0 and dir.y < 0:
		anim.play("up_right")
	elif dir.x < 0 and dir.y > 0:
		anim.play("down_left")
	elif dir.x > 0 and dir.y > 0:
		anim.play("down_right")

@export var health: int = 10

func take_damage(amount: int):
	health -= amount
	print("Nanobot recibió daño. Vida:", health)

	if hud:
		hud.update_lives(health)
	else:
		print("❌ HUD no encontrado")

	if health <= 0:
		die()

func die():
	print("GAME OVER")
	call_deferred("_go_to_game_over")

func _go_to_game_over():
	var tree := Engine.get_main_loop()
	if tree:
		tree.change_scene_to_file("res://scenes/main/GameOver.tscn")
