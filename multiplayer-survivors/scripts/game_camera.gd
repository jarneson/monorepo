extends Camera

onready var players = get_parent().get_node("Players")

var focus: Node

func _grab_player():
	if focus and is_instance_valid(focus):
		return
	else:
		focus = players.get_node_or_null("player_%s" % get_tree().get_network_unique_id())

func _process(_delta):
	_grab_player()
	if not focus:
		return
		
	global_transform.origin.x = focus.global_transform.origin.x
	global_transform.origin.z = focus.global_transform.origin.z + 5
	
