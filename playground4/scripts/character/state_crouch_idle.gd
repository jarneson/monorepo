extends StateMachineState

func enter():
	fsm.actor.standing_shape.disabled = true
	fsm.actor.crouching_shape.disabled = false
	fsm.actor.camera_pivot.transform.origin.y = 0.7

func exit():
	fsm.actor.standing_shape.disabled = false
	fsm.actor.crouching_shape.disabled = true
	fsm.actor.camera_pivot.transform.origin.y = 1.7

func physics_process(_delta):
	if not Input.is_action_pressed("move_crouch") and not fsm.actor.stand_up_raycast.is_colliding():
		return fsm.back()
	fsm.actor.velocity.x = move_toward(fsm.actor.velocity.x, 0.0, 1.0)
	fsm.actor.velocity.z = move_toward(fsm.actor.velocity.z, 0.0, 1.0)
	if Input.get_vector("move_left", "move_right", "move_front", "move_back").length_squared() > 0.0:
		return fsm.next("CrouchWalk")

