extends NetworkedNode

func trigger(scene: PackedScene):
	if is_server:
		fan_out("_spawn_ability", [scene.resource_path])
		_spawn_ability_scene(scene)
	
remote func _spawn_ability(args):
	var res = args[0]
	_spawn_ability_scene(load(res))
	
func _spawn_ability_scene(sc):
	add_child(sc.instance())
