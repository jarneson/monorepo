extends StateMachineState

@export var speed = 2.0

func enter():
	fsm.actor.standing_shape.disabled = true
	fsm.actor.crouching_shape.disabled = false
	fsm.actor.camera_pivot.transform.origin.y = 0.7

func exit():
	fsm.actor.standing_shape.disabled = false
	fsm.actor.crouching_shape.disabled = true
	fsm.actor.camera_pivot.transform.origin.y = 1.7

func physics_process(_delta):
	print("crouch walk")
	if not fsm.actor.is_on_floor():
		return fsm.next("Falling")

	if not Input.is_action_pressed("move_crouch") and not fsm.actor.stand_up_raycast.is_colliding():
		return fsm.back()

	var in_dir = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	var dir = fsm.actor.transform.basis * Vector3(in_dir.x, 0.0, in_dir.y)
	dir = dir.normalized()
	if dir:
		fsm.actor.velocity.x = move_toward(fsm.actor.velocity.x, dir.x*speed, speed)
		fsm.actor.velocity.z = move_toward(fsm.actor.velocity.z, dir.z*speed, speed)
	else:
		fsm.actor.velocity.x = move_toward(fsm.actor.velocity.x, 0, speed)
		fsm.actor.velocity.z = move_toward(fsm.actor.velocity.z, 0, speed)
	if fsm.actor.velocity.x == 0 and fsm.actor.velocity.z == 0:
		return fsm.back()
