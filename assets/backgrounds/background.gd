extends Node2D

@export var scale_amount: float = 0.03
@export var speed: float = 1.2

var _time := 0.0

func _ready():
	scale = Vector2.ONE
	z_index = -10

func _process(delta):
	_time += delta * speed
	var s = 1.0 + sin(_time) * scale_amount
	scale = Vector2.ONE * s
