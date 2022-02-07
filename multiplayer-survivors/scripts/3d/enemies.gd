extends Spatial
var _err

const PhysicsSync = preload("res://scripts/utils/physics_sync.gd")
const Vectors = preload("res://scripts/utils/vectors.gd")
const Enemies2D = preload("res://scripts/2d/enemies.gd")

export(PackedScene) var enemy_scene: PackedScene

var enemies_2d: Enemies2D setget set_enemies_2d

func set_enemies_2d(val):
	if enemies_2d:
		enemies_2d.disconnect("child_added", self, "_on_child_added")
	enemies_2d = val
	_err = enemies_2d.connect("child_added", self, "_on_child_added")

func _on_child_added(node: Node2D, enemy: Enemy):
	var inst = PhysicsSync.new()
	inst.target = node

	var enemy_inst = enemy.scene_3d.instance()
	enemy_inst.enemy_2d = node
	inst.add_child(enemy_inst)

	add_child(inst)
	inst.global_transform.origin = Vectors.Vector2To3(node.global_position)
