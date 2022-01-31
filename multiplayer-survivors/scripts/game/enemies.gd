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
