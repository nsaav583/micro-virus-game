extends CharacterBody2D

@export var speed: float = 140.0
@export var health: int = 1
var player: Node2D

func _ready():
	player = get_tree().get_root().find_child("Nanobot", true, false)

func _physics_process(delta):
	if player == null:
		return
		
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	var sound = $DeathSound
	remove_child(sound)
	get_tree().current_scene.add_child(sound)
	sound.global_position = global_position
	sound.play()
	queue_free()



func _on_hitbox_area_entered(area):
	if area.is_in_group("hurtbox"):
		var player_hit = area.get_parent()
		if player_hit.has_method("take_damage"):
			queue_free()
			player_hit.take_damage(1)
