extends KinematicBody

export var speed: float = 7.5
export var experience: int = 1

onready var physics = $Physics
onready var ai = $AI

var packed_scene: PackedScene

func _process(_delta):
	if not get_tree().is_network_server():
		return
	if ai.target and is_instance_valid(ai.target):
		var dir = (ai.target.global_transform.origin - global_transform.origin).normalized()
		physics.velocity =  Vector2(dir.x, dir.z)* speed

func die():
	Singletons.experience.increase(experience)
	queue_free()
