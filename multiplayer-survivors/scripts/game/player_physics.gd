extends NetworkedNode

onready var kinematic_body: KinematicBody = get_parent()

const scale_factor = 0.01

var velocity: Vector2
var server_velocity: Vector2
var server_origin: Vector2

var sync_fps: float = 2.0
onready var sync_delta = 1.0 / sync_fps

func _ready():
	trusted_peer = 1
	server_origin = Vector2(kinematic_body.global_transform.origin.x, kinematic_body.global_transform.origin.z)

var next_sync = 0
var last_velocity: Vector2
func _physics_process_data(delta):
	var ret = null
	next_sync += delta
	if next_sync >= sync_delta:
		next_sync -= sync_delta
		ret = [Vector2(kinematic_body.global_transform.origin.x, kinematic_body.global_transform.origin.z), velocity]
	elif velocity != last_velocity:
		ret = [Vector2(kinematic_body.global_transform.origin.x, kinematic_body.global_transform.origin.z), velocity]
	last_velocity = velocity
	return ret

func _apply_physics_process(data):
	server_origin = data[0]
	server_velocity = data[1]
	if my_peer_id != trusted_peer:
		velocity = server_velocity

func _physics_process(delta):
	var dist = Vector2(kinematic_body.global_transform.origin.x, kinematic_body.global_transform.origin.z).distance_to(server_origin)
	var weight = clamp(pow(2, dist/4)*scale_factor, 0.0, 1.0)
	kinematic_body.global_transform.origin = kinematic_body.global_transform.origin.linear_interpolate(Vector3(server_origin.x, 0, server_origin.y), weight)
	var look_target = kinematic_body.global_transform.origin + Vector3(velocity.x, 0, velocity.y)
	if not look_target.is_equal_approx(kinematic_body.global_transform.origin):
		kinematic_body.global_transform = kinematic_body.global_transform.looking_at(
			look_target,
			Vector3.UP)
	var res = kinematic_body.move_and_slide(Vector3(velocity.x, 0, velocity.y), Vector3.UP)
	velocity = Vector2(res.x, res.z)
	server_origin += velocity*delta
