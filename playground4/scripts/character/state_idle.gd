extends StateMachineState

@export var jump_velocity = 4.9

func physics_process(_delta):
	if not fsm.actor.is_on_floor():
		return fsm.next("Falling")
	if Input.is_action_pressed("move_crouch"):
		return fsm.next("Crouch")
	if Input.get_vector("move_left", "move_right", "move_front", "move_back").length_squared() > 0.0:
		return fsm.next("Walk")
	if Input.is_action_pressed("move_jump"):
		return fsm.next("Jumping", [jump_velocity])
	fsm.actor.velocity.x = move_toward(fsm.actor.velocity.x, 0.0, 1.0)
	fsm.actor.velocity.z = move_toward(fsm.actor.velocity.z, 0.0, 1.0)
