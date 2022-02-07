extends Position2D

const Enemy = preload("res://scripts/resources/enemy.gd")

export var rate: float = 1.0
export(Resource) var enemy_resource: Resource

export(NodePath) var enemies_node_path: String
onready var enemies: Node2D = get_node(enemies_node_path)
onready var enemy: Enemy = enemy_resource

var next_spawn: float
var spawns: int

func _process(delta: float):
	next_spawn -= delta
	if next_spawn <= 0:
		next_spawn += rate
		enemies.trigger(enemy, global_position, "%s_%s" % [name, spawns])
		spawns += 1
