extends Spatial
var _err

const Projectiles2D = preload("res://scripts/2d/projectiles.gd")
const PhysicsSync = preload("res://scripts/utils/physics_sync.gd")
const Vectors = preload("res://scripts/utils/vectors.gd")

var projectiles_2d: Projectiles2D setget set_projectiles_2d

func set_projectiles_2d(val):
	if projectiles_2d:
		projectiles_2d.disconnect("child_added", self, "_on_child_added")
	projectiles_2d = val
	_err = projectiles_2d.connect("child_added", self, "_on_child_added")

func _on_child_added(node: Node2D, ability: PlayerAbility):
	var inst = PhysicsSync.new()
	inst.target = node

	var projectile_inst = ability.scene_3d.instance()
	projectile_inst.projectile_2d = node
	inst.add_child(projectile_inst)

	add_child(inst)
	inst.global_transform.origin = Vectors.Vector2To3(node.global_position)
