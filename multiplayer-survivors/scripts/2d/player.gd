extends KinematicBody2D

onready var physics = $Physics

var last_direction: Vector2 = Vector2.DOWN

func _ready():
	Singletons.follow_node_2d = self
	physics.speed = 500.0

func _process(_delta):
	if Singletons.inputs.input:
		last_direction = Singletons.inputs.input.normalized()
		physics.direction = last_direction
	else:
		physics.direction = Vector2.ZERO
