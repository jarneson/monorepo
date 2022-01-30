extends KinematicBody

export var speed: float = 7.5

onready var physics = $Physics
onready var ai = $AI

func _process(_delta):
	if not get_tree().is_network_server():
		return
	if ai.target:
		physics.velocity = (ai.target.global_transform.origin - global_transform.origin).normalized() * speed
