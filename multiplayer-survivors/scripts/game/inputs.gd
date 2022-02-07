extends Node

var input: Vector2

func _ready():
	Singletons.inputs = self

func _process(_delta):
	var result = Vector2.ZERO
	result.y += Input.get_action_strength("movement_forward")
	result.y -= Input.get_action_strength("movement_back")
	result.x += Input.get_action_strength("movement_right")
	result.x -= Input.get_action_strength("movement_left")
	input = result
