extends StateMachineState

@export var gravity = 9.8
@export var air_control = 3.0

func physics_process(delta):
	print("fall")
	if fsm.actor.is_on_floor():
		return fsm.back()
	if fsm.actor.is_on_wall() and Input.is_action_pressed("move_sprint"):
		return fsm.next("WallRunning")
	fsm.actor.velocity.y -= gravity * delta
	var in_dir = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	if in_dir != Vector2.ZERO:
		var dir = fsm.actor.transform.basis * Vector3(in_dir.x, 0.0, in_dir.y)
		dir = dir.normalized()
		dir *= max(Vector2(fsm.actor.velocity.x, fsm.actor.velocity.z).length(), 1.0)
		fsm.actor.velocity.x = move_toward(fsm.actor.velocity.x, dir.x, air_control*delta)
		fsm.actor.velocity.z = move_toward(fsm.actor.velocity.z, dir.z, air_control*delta)
