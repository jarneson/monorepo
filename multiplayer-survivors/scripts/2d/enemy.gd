extends KinematicBody2D

onready var physics = $Physics

func _process(_delta):
	var nearest = get_tree().get_nodes_in_group("players")
	if nearest:
		physics.direction = (nearest[0].global_position - global_position).normalized()
	else:
		physics.direction = Vector2.ZERO
