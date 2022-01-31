extends Spatial

export var rate: float = 1.0
export var hitpoints: int = 10

export(NodePath) var enemies_node_path: String
onready var enemies = get_node(enemies_node_path)

export var enemy_scene: PackedScene

onready var next_spawn = rate
onready var pos2 = Vector2(global_transform.origin.x, global_transform.origin.z)

var spawns: int

func _process(delta):
	next_spawn -= delta
	if next_spawn <= 0:
		next_spawn += rate
		enemies.trigger(enemy_scene, hitpoints, pos2, "%s_%s" % [name, spawns])
		spawns += 1
