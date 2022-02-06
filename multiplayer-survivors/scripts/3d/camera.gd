extends Camera

const Vectors = preload("res://scripts/utils/vectors.gd")

func _process(_delta):
	if Singletons.follow_node_2d:
		global_transform.origin = Vectors.Vector2To3(Singletons.follow_node_2d.global_position)
		global_transform.origin.y = 50.0
