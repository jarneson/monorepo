extends Node

const scale_factor = 0.01

onready var kinematic_body: KinematicBody = get_parent()
var velocity: Vector2
onready var server_origin: Vector2 = Vector2(kinematic_body.global_transform.origin.x, kinematic_body.global_transform.origin.z)

func _physics_process(delta):
	var dist = Vector2(kinematic_body.global_transform.origin.x, kinematic_body.global_transform.origin.z).distance_to(server_origin)
	var weight = clamp(pow(2, dist/4)*scale_factor, 0.0, 1.0)
	kinematic_body.global_transform.origin = kinematic_body.global_transform.origin.linear_interpolate(Vector3(server_origin.x, 0, server_origin.y), weight)
	var look_target = kinematic_body.global_transform.origin + Vector3(velocity.x, 0, velocity.y)
	if not look_target.is_equal_approx(kinematic_body.global_transform.origin):
		kinematic_body.global_transform = kinematic_body.global_transform.looking_at(
			look_target,
			Vector3.UP)
	var res = kinematic_body.move_and_slide(Vector3(velocity.x, 0, velocity.y), Vector3.UP, 2)
	velocity = Vector2(res.x, res.z)
	server_origin += velocity*delta
