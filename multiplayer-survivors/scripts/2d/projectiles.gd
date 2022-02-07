extends Node2D

const Player = preload("res://scripts/2d/player.gd")

signal child_added(node, res)

func _ready():
	Singletons.projectiles_2d = self

func trigger(ability: PlayerAbility, player: Player):
	var inst = ability.scene_2d.instance()
	inst.player = player
	inst.calculate_stats()
	inst.global_position = player.global_position
	inst.direction = player.last_direction
	inst.rotation = player.last_direction.angle()
	add_child(inst)
	emit_signal("child_added", inst, ability)
