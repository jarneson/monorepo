extends Node3D

var options: Array = []
var grid_position: Vector3

func entropy() -> int:
	return options.size()

func collapse():
	var weight_sum := 0.0
	for o in options:
		weight_sum += o.weight
	var r_weight = randf_range(0.01, weight_sum)
	var choice := 0
	for o_idx in options.size():
		r_weight -= options[o_idx].weight
		if r_weight <= 0.0:
			choice = o_idx
			break
	options = [options[choice]]

func _process(_delta):
	if entropy() == 1 and get_node_or_null("inst") == null:
		var inst = options[0].scene.instantiate()
		inst.name = "inst"
		add_child(inst)
		inst.rotate_x(deg2rad(options[0].rotation.x))
		inst.rotate_y(deg2rad(options[0].rotation.y))
		inst.rotate_z(deg2rad(options[0].rotation.z))

const dir_to_socket = {
	Vector3.UP: "socket_y_pos",
	Vector3.DOWN: "socket_y_neg",
	Vector3.LEFT: "socket_x_neg",
	Vector3.RIGHT: "socket_x_pos",
	Vector3.FORWARD: "socket_z_neg",
	Vector3.BACK: "socket_z_pos",
}

const dir_to_mask = {
	Vector3.UP: "socket_mask_y_pos",
	Vector3.DOWN: "socket_mask_y_neg",
	Vector3.LEFT: "socket_mask_x_neg",
	Vector3.RIGHT: "socket_mask_x_pos",
	Vector3.FORWARD: "socket_mask_z_neg",
	Vector3.BACK: "socket_mask_z_pos",
}

func out_mask(dir: Vector3) -> int:
	var out = 0
	for o in options:
		out |= o.get(dir_to_socket[dir])
	return out

func in_mask(dir: Vector3) -> int:
	var out = 0
	for o in options:
		out |= o.get(dir_to_mask[dir])
	return out

# constrain based on `other` sending a signal along `dir`
func constrain(other, dir: Vector3) -> bool:
	if options.size() <= 1:
		return false
	var mutated := false
	var other_out_mask: int = other.out_mask(dir)
	var other_in_mask: int = other.in_mask(dir)
	for o_idx in range(options.size() - 1, -1, -1):
		if other_out_mask & options[o_idx].get(dir_to_mask[-dir]) == 0 or other_in_mask & options[o_idx].get(dir_to_socket[-dir]) == 0:
			options.remove_at(o_idx)
			mutated = true
	if options.size() == 0:
		print("emptied options at %s from %s is %s" % [grid_position, other.grid_position, other_out_mask])
		return false
	return mutated
