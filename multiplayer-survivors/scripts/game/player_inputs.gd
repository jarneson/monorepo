extends NetworkedNode

var input: Vector3
var direction: Vector3

func _ready():
	trusted_peer = get_parent().owner_id

var last_direction: Vector3

func _unhandled_input(event):
	if my_peer_id != trusted_peer:
		return
	if event.is_action_pressed("movement_forward"):
		input.z -= 1
	if event.is_action_released("movement_forward"):
		input.z += 1
	if event.is_action_pressed("movement_back"):
		input.z += 1
	if event.is_action_released("movement_back"):
		input.z -= 1
	if event.is_action_pressed("movement_left"):
		input.x -= 1
	if event.is_action_released("movement_left"):
		input.x += 1
	if event.is_action_pressed("movement_right"):
		input.x += 1
	if event.is_action_released("movement_right"):
		input.x -= 1

	direction = input.normalized()
	if last_direction != direction:
		rpc_id(1, "set_direction", [direction])
	last_direction = direction

master func set_direction(args):
	var caller = get_tree().get_rpc_sender_id()
	assert(caller == trusted_peer, "got rpc from untrusted peer %s" % [caller])
	direction = args[0]
