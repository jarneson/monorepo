extends Node3D

var linear_velocity: Vector3
var lifetime: float
var damage: int
var damage_range: float
var speed: float
var size: float
var ricochets: int
var ricochet_damage: float
var damage_falloff: float
var homing_speed: float
var homing_distance: float
var explosion_radius: float
var pierce: int
var shatter: int
var shatter_damage: float
var toxin: float
var toxin_duration: float

var direction: Vector3

func _get_movement_shape():
	var movement_shape = BoxShape3D.new()
	movement_shape.size = Vector3(0.1, 0.1, 0.1)
	return movement_shape

const margin = 0.1

# [applied_motion, collision_margin, collision_normal, collision_body]
func _move_and_collide(motion: Vector3):
	var physics_state = PhysicsServer3D.space_get_direct_state(get_world_3d().space)
	var q = PhysicsShapeQueryParameters3D.new()
	q.shape = _get_movement_shape()
	q.transform = global_transform
	q.motion = motion
	var result = physics_state.cast_motion(q)
	if result[0] == 1 and result[1] == 1:
		global_transform.origin += motion
		return [motion, null, null, null]
	else:
		var q2 = PhysicsShapeQueryParameters3D.new()
		q2.shape = q.shape
		q2.transform = Transform3D(global_transform)
		q2.transform.origin += motion*result[1]
		var rest_result = physics_state.get_rest_info(q2)
		if rest_result:
			global_transform.origin += motion*result[0]*(1.0-margin)
			return [motion*result[0]*(1.0-margin), motion*result[1]-motion*result[0]*(1.0-margin), rest_result.normal, instance_from_id(rest_result.collider_id)]
		else:
			global_transform.origin += motion*result[0]
			return [motion*result[0]*(1.0-margin), null, null, null]

func _physics_process(delta):
	# query physics state
	var motion = direction * speed * delta
	var impacts = []
	for i in 5:
		var result = _move_and_collide(motion)
		if result[1] == null:
			break
		motion -= result[0]
		motion = motion.bounce(result[2])
		direction = motion.normalized()
		# decide if we ricochet, pierce, or terminate
		impacts.push_back(global_transform.origin)
	if impacts:
		print(impacts)
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
