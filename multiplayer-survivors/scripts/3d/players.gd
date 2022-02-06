extends Spatial
var _err

const PhysicsSync = preload("res://scripts/utils/physics_sync.gd")
const Vectors = preload("res://scripts/utils/vectors.gd")
const Players2D = preload("res://scripts/2d/players.gd")

export(PackedScene) var player_scene: PackedScene

var players_2d: Players2D setget set_players_2d

func set_players_2d(val):
	if players_2d:
		players_2d.disconnect("child_added", self, "_on_child_added")
	players_2d = val
	_err = players_2d.connect("child_added", self, "_on_child_added")

func _on_child_added(node):
	var inst = PhysicsSync.new()
	inst.target = node

	var player = player_scene.instance()
	inst.add_child(player)

	add_child(inst)
	inst.global_transform.origin = Vectors.Vector2To3(node.global_position)

