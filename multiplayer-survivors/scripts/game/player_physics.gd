extends NetworkedNode

onready var kinematic_body: KinematicBody = get_parent()

func interp():
	return false

func _physics_process_data(_delta):
	return [kinematic_body.global_transform, Vector3(rand_range(-1,1), 0, rand_range(-1,1)).normalized()]

func _apply_physics_process(data):
	kinematic_body.global_transform = data[0]
	kinematic_body.move_and_slide(data[1], Vector3.UP)
