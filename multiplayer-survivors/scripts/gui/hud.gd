extends MarginContainer

export(NodePath) var players_node_path
onready var players = get_node(players_node_path)

onready var experience_level = $V/Experience/Level
onready var experience_bar = $V/Experience/Bar

var focus: Node

func _grab_player():
	if focus and is_instance_valid(focus):
		return
	else:
		focus = players.get_node_or_null("player_%s" % get_tree().get_network_unique_id())

func _process(_delta):
	experience_level.text = str(Singletons.experience.level)
	experience_bar.max_value = Singletons.experience.next_level_amount()
	experience_bar.value = Singletons.experience.experience
	_grab_player()
	if not focus:
		return
