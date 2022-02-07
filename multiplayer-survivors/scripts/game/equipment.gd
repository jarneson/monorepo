extends Node

export(Array, Resource) var affixes

onready var player = get_parent().get_parent()

func _ready():
	parse_affixes()

var affix_cooldowns: Array

func parse_affixes():
	affix_cooldowns = []
	for a in affixes:
		if a.provide_ability:
			affix_cooldowns.push_back(0)
		else:
			affix_cooldowns.push_back(null)

func _physics_process(delta):
	for idx in range(affixes.size()):
		if affix_cooldowns[idx] == null:
			continue
		affix_cooldowns[idx] -= delta
		if affix_cooldowns[idx] <= 0:
			affix_cooldowns[idx] += affixes[idx].provide_ability.cooldown * float(100-player.reduced_cooldown)/100.0
			Singletons.projectiles_2d.trigger(affixes[idx].provide_ability, (player))
