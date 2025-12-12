extends Node2D

@export var scale_amount: float = 0.05
@export var speed: float = 2.0          

var t: float = 0.0

func _process(delta):
	t += delta * speed
	var s = 1.0 + sin(t) * scale_amount
	scale = Vector2(s, s)
