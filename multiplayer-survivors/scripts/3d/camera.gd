extends Camera

const Vectors = preload("res://scripts/utils/vectors.gd")

const height := 20.0
const offset := 5.0

func _process(_delta):
	if Singletons.follow_node_3d:
		global_transform.origin = Singletons.follow_node_3d.global_transform.origin
		global_transform.origin.z += offset
		global_transform.origin.y = height
		look_at(Singletons.follow_node_3d.global_transform.origin, Vector3.UP)
