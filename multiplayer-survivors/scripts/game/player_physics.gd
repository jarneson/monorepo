extends NetworkedNode

onready var kinematic_body: KinematicBody = get_parent()

const scale_factor = 0.01

var velocity: Vector3
var server_velocity: Vector3
var server_transform: Transform

func _ready():
	trusted_peer = kinematic_body.owner_id
	server_transform = kinematic_body.global_transform

func _physics_process_data(_delta):
	return [kinematic_body.global_transform, velocity]

func _apply_physics_process(data):
	server_transform = data[0]
	server_velocity = data[1]
	if my_peer_id != trusted_peer:
		velocity = server_velocity

func _physics_process(delta):
	var dist = kinematic_body.global_transform.origin.distance_to(server_transform.origin)
	var weight = clamp(pow(2, dist/4)*scale_factor, 0.0, 1.0)
	kinematic_body.global_transform = kinematic_body.global_transform.interpolate_with(server_transform, weight)
	velocity = kinematic_body.move_and_slide(velocity, Vector3.UP)
	server_transform.origin += velocity*delta
