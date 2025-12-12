extends Area2D

@export var speed: float = 700.0
var direction: Vector2 = Vector2.ZERO
@export var lifetime: float = 2.0

func _ready():
	# Destrucción automática
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta):
	position += direction * speed * delta

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		var enemy = area.get_parent()
		if enemy.has_method("take_damage"):
			enemy.take_damage(1)
		print("porfin me mori")
		queue_free()
