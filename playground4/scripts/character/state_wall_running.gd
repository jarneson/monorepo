extends StateMachineState

@export var gravity = 4.9
@export var speed = 16.0
@export var acceleration = 8.0
@export var horizontal_jump_velocity = 8.0
@export var jump_velocity = 4.0

func physics_process(delta):
	if not fsm.actor.is_on_wall() or not Input.is_action_pressed("move_sprint"):
		return fsm.back()
	if Input.is_action_pressed("move_jump"):
		fsm.actor.velocity = fsm.actor.velocity.slide(fsm.actor.get_wall_normal())
		fsm.actor.velocity.x += fsm.actor.get_wall_normal().x * horizontal_jump_velocity
		fsm.actor.velocity.z += fsm.actor.get_wall_normal().z * horizontal_jump_velocity
		return fsm.next("Jumping", [jump_velocity])
	fsm.actor.velocity.y = max(0, fsm.actor.velocity.y - gravity * delta)
	var in_dir = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	var dir = fsm.actor.transform.basis * Vector3(in_dir.x, 0.0, in_dir.y)
	dir = dir.normalized().slide(fsm.actor.get_wall_normal()) * speed * fsm.actor.velocity.y
	fsm.actor.velocity.x = move_toward(fsm.actor.velocity.x, dir.x, acceleration*delta)
	fsm.actor.velocity.z = move_toward(fsm.actor.velocity.z, dir.z, acceleration*delta)
