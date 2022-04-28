extends StateMachineState

@export var speed = 6.0

func physics_process(_delta):
	print("walk")

	var in_dir = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	var dir = fsm.actor.transform.basis * Vector3(in_dir.x, 0.0, in_dir.y)
	dir = dir.normalized()
	if dir == Vector3.ZERO and fsm.actor.velocity.x == 0 and fsm.actor.velocity.z == 0:
		return fsm.back()

	if not fsm.actor.is_on_floor():
		return fsm.next("Falling")
	if Input.is_action_pressed("move_crouch"):
		return fsm.next("Crouch")
	if Input.is_action_pressed("move_sprint"):
		return fsm.next("Run")

	if dir:
		fsm.actor.velocity.x = move_toward(fsm.actor.velocity.x, dir.x*speed, speed)
		fsm.actor.velocity.z = move_toward(fsm.actor.velocity.z, dir.z*speed, speed)
	else:
		fsm.actor.velocity.x = move_toward(fsm.actor.velocity.x, 0, speed)
		fsm.actor.velocity.z = move_toward(fsm.actor.velocity.z, 0, speed)
