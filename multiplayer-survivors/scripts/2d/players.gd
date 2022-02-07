extends Node2D

signal child_added(node)

export(PackedScene) var player_scene: PackedScene

func trigger(scene: PackedScene, _hp: int, position: Vector2, name: String):
	var inst = scene.instance()
	inst.name = name
	inst.global_position = position
	add_child(inst)
	emit_signal("child_added", inst)

func start():
	trigger(player_scene, 10, Vector2.ZERO, "player_0")
