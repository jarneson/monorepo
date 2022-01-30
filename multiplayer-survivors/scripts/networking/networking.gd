extends Node
class_name Networking
var _nul

const DEFAULT_PORT = 2948
const MAX_PEERS = 20

signal network_ready

signal player_disconnected(peer_id)

var player_name: String

func _ready():
	_nul = get_tree().connect("network_peer_connected", self, "_player_connected")
	_nul = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	_nul = get_tree().connect("connected_to_server", self, "_connected_to_server")
	_nul = get_tree().connect("connection_failed", self, "_connected_failed")
	_nul = get_tree().connect("server_disconnected", self, "_server_disconnected")

func initialize():
	if start_server() != OK:
		join_server()

func _player_connected(id):
	print("player_connected: %s" % [id])

func _player_disconnected(id):
	print("player_disconnected: %s" % [id])
	emit_signal("player_disconnected", id)

func _connected_to_server():
	emit_signal("network_ready")

func _connection_failed():
	print("connection failed")
	get_tree().quit()

func _server_disconnected():
	print("server disconnected")
	get_tree().quit()

func start_server() -> int:
	player_name = "Server"
	var host = NetworkedMultiplayerENet.new()

	var err = host.create_server(DEFAULT_PORT, MAX_PEERS)
	if err != OK:
		return err

	get_tree().network_peer = host
	print("started server")
	emit_signal("network_ready")
	return OK

func join_server():
	player_name = "Client"
	var host = NetworkedMultiplayerENet.new()
	var err = host.create_client('127.0.0.1', DEFAULT_PORT)
	if err != OK:
		print("failed to connect: %s" % [err])
		get_tree().quit()
		return
	get_tree().network_peer = host
