extends NetworkedNode

onready var kinematic_body: KinematicBody = get_parent()

const scale_factor = 0.01

var velocity: Vector3
var server_velocity: Vector3
var server_origin: Vector3

func _ready():
	trusted_peer = 1
	server_origin = kinematic_body.global_transform.origin

func _physics_process_data(_delta):
	return [kinematic_body.global_transform.origin, velocity]

func _apply_physics_process(data):
	server_origin = data[0]
	server_velocity = data[1]
	if my_peer_id != trusted_peer:
		velocity = server_velocity

func _physics_process(delta):
	var dist = kinematic_body.global_transform.origin.distance_to(server_origin)
	var weight = clamp(pow(2, dist/4)*scale_factor, 0.0, 1.0)
	kinematic_body.global_transform.origin = kinematic_body.global_transform.origin.linear_interpolate(server_origin, weight)
	if velocity:
		kinematic_body.global_transform = kinematic_body.global_transform.looking_at(
			kinematic_body.global_transform.origin + velocity,
			Vector3.UP)
	velocity = kinematic_body.move_and_slide(velocity, Vector3.UP)
	server_origin += velocity*delta
