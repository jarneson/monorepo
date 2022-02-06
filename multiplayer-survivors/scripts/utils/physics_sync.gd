extends Spatial

const Vectors = preload("res://scripts/utils/vectors.gd")

var target

func _process(_delta):
	if is_instance_valid(target):
		global_transform.origin = Vectors.Vector2To3(target.global_position)
