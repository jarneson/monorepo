extends KinematicBody

export var speed: float = 15.0

var owner_id: int
var direction: Vector3

onready var inputs = $Inputs
onready var physics = $Physics

func _physics_process(_delta):
	if get_tree().is_network_server() || get_tree().get_network_unique_id() == owner_id:
		direction = inputs.direction
		physics.velocity = inputs.direction * speed
