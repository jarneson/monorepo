extends NetworkedNode

export var scene: PackedScene
export var cooldown: float
export var top_level: bool

onready var abilities = get_parent()
onready var next_cast = cooldown

func _process_data(delta):
	if next_cast <= 0:
		abilities.trigger(scene)
		next_cast += cooldown
		return [next_cast]
	return null

puppet func _apply_process(args):
	next_cast = args[0]

func _process(delta):
	next_cast -= delta
