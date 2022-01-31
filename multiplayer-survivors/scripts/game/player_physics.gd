extends NetworkedNode

onready var kinematic_body: KinematicBody = get_parent()

const scale_factor = 0.01

var velocity: Vector2
var server_velocity: Vector2
var server_origin: Vector2

func _ready():
	trusted_peer = 1
	server_origin = Vector2(kinematic_body.global_transform.origin.x, kinematic_body.global_transform.origin.z)

func _physics_process_data(_delta):
	return [Vector2(kinematic_body.global_transform.origin.x, kinematic_body.global_transform.origin.z), velocity]

func _apply_physics_process(data):
	server_origin = data[0]
	server_velocity = data[1]
	if my_peer_id != trusted_peer:
		velocity = server_velocity

func _physics_process(delta):
	var dist = Vector2(kinematic_body.global_transform.origin.x, kinematic_body.global_transform.origin.z).distance_to(server_origin)
	var weight = clamp(pow(2, dist/4)*scale_factor, 0.0, 1.0)
	kinematic_body.global_transform.origin = kinematic_body.global_transform.origin.linear_interpolate(Vector3(server_origin.x, 0, server_origin.y), weight)
	if velocity != Vector2.ZERO:
		kinematic_body.global_transform = kinematic_body.global_transform.looking_at(
			kinematic_body.global_transform.origin + Vector3(velocity.x, 0, velocity.y),
			Vector3.UP)
	var res = kinematic_body.move_and_slide(Vector3(velocity.x, 0, velocity.y), Vector3.UP)
	velocity = Vector2(res.x, res.z)
	server_origin += velocity*delta
