extends Camera2D

func _process(_delta):
	if Singletons.follow_node_2d:
		global_position = Singletons.follow_node_2d.global_position
