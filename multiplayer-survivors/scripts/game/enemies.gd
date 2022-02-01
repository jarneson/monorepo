extends NetworkedNode

func _new_connection(peer_id):
	for n in get_children():
		rpc_id(peer_id, "_spawn_enemy", [n.packed_scene.resource_path, n.get_node("Hitpoints").hitpoints, Vector2(n.global_transform.origin.x, n.global_transform.origin.z), n.name])
		
func trigger(scene: PackedScene, hitpoints: int, pos: Vector2, name: String):
	if is_server:
		fan_out("_spawn_enemy", [scene.resource_path, hitpoints, pos, name])
		_spawn_enemy_scene(scene, hitpoints, pos, name)
	
remote func _spawn_enemy(args):
	var res = args[0]
	_spawn_enemy_scene(load(res), args[1], args[2], args[3])
	
func _spawn_enemy_scene(sc: PackedScene, hp: int, pos: Vector2, name: String):
	var inst = sc.instance()
	inst.name = name
	inst.packed_scene = sc
	inst.transform.origin = Vector3(pos.x, 0, pos.y)
	add_child(inst)
	inst.get_node("Hitpoints").hitpoints = hp

var scan_index = 0

func scan_size():
	return min(max(get_child_count()/60, 10), get_child_count())

var print_next = 1.0
func _physics_process_data(_delta):
	var ret = {}
	print_next -= _delta
	if print_next <= 0:
		print("syncing %s / %s" % [scan_size(), get_child_count()])
		print_next += 1.0
	for i in range(scan_size()):
		if scan_index >= get_child_count():
			scan_index = 0
		var n = get_child(scan_index)
		ret[n.name] = [Vector2(n.global_transform.origin.x, n.global_transform.origin.z), n.get_node("Physics").velocity]
		scan_index += 1
	return [ret]

puppet func _apply_physics_process(data):
	for k in data[0]:
		var n = get_node(k).get_node("Physics")
		n.server_origin = data[0][k][0]
		n.velocity = data[0][k][1]
