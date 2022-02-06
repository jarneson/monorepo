extends Node2D

const Enemy = preload("res://scripts/resources/enemy.gd")

signal child_added(node, res)

const EnemyPhysics = preload("res://scripts/2d/enemy_physics.gd")

func trigger(enemy: Enemy, hp: int, position: Vector2, name: String):
	var inst = enemy.scene_2d.instance()
	inst.name = name
	inst.global_position = position
	var phys = EnemyPhysics.new()
	phys.name = "Physics"
	phys.speed = enemy.speed
	inst.add_child(phys)
	add_child(inst)
	emit_signal("child_added", inst, enemy)

var last_log: float
func _process(delta: float):
	last_log -= delta
	if last_log <= 0:
		print("%s enemies" % get_child_count())
		last_log += 1.0
	
