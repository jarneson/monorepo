extends MarginContainer

export var level_up_scene: PackedScene

onready var experience_level = $V/Experience/Level
onready var experience_bar = $V/Experience/Bar

var focus: Node

func _ready():
	Singletons.experience.connect("level_up", self, "_on_level_up")

func _grab_player():
	if focus and is_instance_valid(focus):
		return
	else:
		focus = Singletons.follow_node_2d

func _process(_delta):
	experience_level.text = str(Singletons.experience.level)
	experience_bar.max_value = Singletons.experience.next_level_amount()
	experience_bar.value = Singletons.experience.experience
	_grab_player()
	if not focus:
		return

func _on_level_up():
	var inst = level_up_scene.instance()
	inst.player = focus
	add_child(inst)
