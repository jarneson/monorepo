extends Node

onready var parent: Spatial = get_parent()

var target

func _process(_delta):
	if not get_tree().is_network_server():
		return
	var players = get_tree().get_nodes_in_group("players")
	var nearest = null
	for p in players:
		if not nearest:
			nearest = p
		if p.global_transform.origin.distance_squared_to(parent.global_transform.origin) < nearest.global_transform.origin.distance_squared_to(parent.global_transform.origin) :
			nearest = p

	target = nearest
