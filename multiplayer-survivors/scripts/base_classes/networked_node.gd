extends Node
class_name NetworkedNode

export var connected_peers: Array

onready var is_server: bool = get_tree().is_network_server()
onready var my_peer_id: int = get_tree().get_network_unique_id()

var trusted_peer: int = 1

func _ready():
	rpc_id(1, "new_connection", my_peer_id)

func _exit_tree():
	rpc_id(1, "end_connection", my_peer_id)

master func new_connection(peer_id):
	print("%s adding %s" % [name, peer_id])
	connected_peers.push_back(peer_id)
	_new_connection(peer_id)
	rpc_id(peer_id, "_connected")

master func end_connection(peer_id):
	print("%s erasing %s" % [name, peer_id])
	connected_peers.erase(peer_id)

master func _new_connection(_peer_id):
	pass

puppetsync func _connected():
	pass

func _on_connect():
	pass

func interp():
	return false

func fan_out(name, data):
	for peer_id in connected_peers:
		if peer_id != 1:
			rpc_id(peer_id, name, data)

func fan_out_unreliable(name, data):
	for peer_id in connected_peers:
		if peer_id != 1:
			rpc_unreliable_id(peer_id, name, data)

func _process(delta):
	if is_server:
		var data = _process_data(delta)
		if not data:
			return
		fan_out_unreliable("_apply_process", data)

func _process_data(_delta):
	pass

puppet func _apply_process(_data):
	pass

func _physics_process(delta):
	if is_server:
		var data = _physics_process_data(delta)
		if not data:
			return
		fan_out_unreliable("_apply_physics_process", data)

func _physics_process_data(_delta):
	pass

puppet func _apply_physics_process(_data):
	pass
