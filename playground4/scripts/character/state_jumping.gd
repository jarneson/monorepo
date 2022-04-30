extends StateMachineState

@export var gravity = 9.8
@export var air_control = 10.0

func enter(vel):
	fsm.actor.velocity.y += vel

func physics_process(delta):
	if fsm.actor.is_on_wall() and Input.is_action_pressed("move_sprint"):
		fsm.back()
		fsm.next("Falling")
		return fsm.next("WallRunning")

	if fsm.actor.velocity.y <= 0.0:
		return fsm.back()
	fsm.actor.velocity.y -= gravity * delta

	var in_dir = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	if in_dir != Vector2.ZERO:
		var dir = fsm.actor.transform.basis * Vector3(in_dir.x, 0.0, in_dir.y)
		dir = dir.normalized()
		dir *= max(Vector2(fsm.actor.velocity.x, fsm.actor.velocity.z).length(), 1.0)
		fsm.actor.velocity.x = move_toward(fsm.actor.velocity.x, dir.x, air_control*delta)
		fsm.actor.velocity.z = move_toward(fsm.actor.velocity.z, dir.z, air_control*delta)
