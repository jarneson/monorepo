extends Node
class_name NetworkedNode

export var connected_peers: Array

onready var is_server: bool = get_tree().is_network_server()
onready var my_peer_id: int = get_tree().get_network_unique_id()

var trusted_peer: int = 1
var server_freed = false
var physics_reliable = false
var process_reliable = false

onready var network = get_tree().get_current_scene().get_node("Network")

func _ready():
	network.connect("player_disconnected", self, "end_connection")
	rpc_id(1, "new_connection", my_peer_id)

master func new_connection(peer_id):
	# print("%s adding %s" % [name, peer_id])
	connected_peers.push_back(peer_id)
	_new_connection(peer_id)
	rpc_id(peer_id, "_connected")

master func end_connection(peer_id):
	# print("%s erasing %s" % [name, peer_id])
	connected_peers.erase(peer_id)
	_end_connection(peer_id)

master func _new_connection(_peer_id):
	pass

master func _end_connection(_peer_id):
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
		_apply_process(data)
		if process_reliable:
			fan_out("_apply_process", data)
		else:
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
		_apply_physics_process(data)
		if physics_reliable:
			fan_out("_apply_physics_process", data)
		else:
			fan_out_unreliable("_apply_physics_process", data)

func _physics_process_data(_delta):
	pass

puppet func _apply_physics_process(_data):
	pass
