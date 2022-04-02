extends Node3D

var options: Array = []

func entropy() -> int:
	return options.size()

func collapse():
	var choice = randi() % entropy()
	options = [options[choice]]

func _process(_delta):
	if entropy() == 1 and get_node_or_null("inst") == null:
		var inst = options[0].scene.instantiate()
		inst.name = "inst"
		add_child(inst)
		inst.rotate_x(deg2rad(options[0].rotation.x))
		inst.rotate_y(deg2rad(options[0].rotation.y))
		inst.rotate_z(deg2rad(options[0].rotation.z))

const dir_to_field = {
	Vector3.UP: "socket_y_pos",
	Vector3.DOWN: "socket_y_neg",
	Vector3.LEFT: "socket_x_neg",
	Vector3.RIGHT: "socket_x_pos",
	Vector3.FORWARD: "socket_z_neg",
	Vector3.BACK: "socket_z_pos",
}

func sockets(dir: Vector3) -> Array[int]:
	var valid_sockets = {}
	for o in options:
		valid_sockets[o.get(dir_to_field[dir])] = true
	return valid_sockets.keys()

func constrain(dir: Vector3, sockets: Array[int]) -> bool:
	if options.size() <= 1:
		return false
	var mutated := false
	for o_idx in range(options.size() - 1, -1, -1):
		if options[o_idx].get(dir_to_field[-dir]) not in sockets:
			options.remove_at(o_idx)
			mutated = true
	return mutated
