extends NetworkedNode

export(PackedScene) var player_scene

var players = {}

func _ready():
	print("ready!")

func _new_connection(peer_id):
	for existing_id in connected_peers:
		rpc_id(peer_id, "spawn_player", [existing_id])
	spawn_player([peer_id])
	fan_out("spawn_player", [peer_id])

puppetsync func spawn_player(args):
	var client_id = args[0]
	var name = "player_%s" % client_id
	var n = get_node_or_null(name)
	if n:
		return

	n = player_scene.instance()
	n.name = name
	n.owner_id = client_id
	add_child(n)