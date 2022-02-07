extends Spatial

const Vectors = preload("res://scripts/utils/vectors.gd")

var target: Node2D
var current: Vector3
var previous: Vector3

func _ready():
	current = Vectors.Vector2To3(target.global_position)
	previous = current

func _physics_process(_delta):
	if is_instance_valid(target):
		previous = current
		current = Vectors.Vector2To3(target.global_position)
	

func _process(_delta):
	if is_instance_valid(target):
		var f = Engine.get_physics_interpolation_fraction()
		global_transform.origin = lerp(previous, current, f)
