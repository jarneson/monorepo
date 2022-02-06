extends Node

var input: Vector2

func _ready():
	Singletons.inputs = self

func _unhandled_input(event):
	if event.is_action_pressed("movement_forward"):
		input.y += 1
	if event.is_action_released("movement_forward"):
		input.y -= 1
	if event.is_action_pressed("movement_back"):
		input.y -= 1
	if event.is_action_released("movement_back"):
		input.y += 1
	if event.is_action_pressed("movement_left"):
		input.x -= 1
	if event.is_action_released("movement_left"):
		input.x += 1
	if event.is_action_pressed("movement_right"):
		input.x += 1
	if event.is_action_released("movement_right"):
		input.x -= 1
