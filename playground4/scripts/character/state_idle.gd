extends StateMachineState

func physics_process(_delta):
	print("idle")
	if not fsm.actor.is_on_floor():
		fsm.next("Falling")
		return
	if Input.is_action_pressed("move_crouch"):
		return fsm.next("Crouch")
	if Input.get_vector("move_left", "move_right", "move_front", "move_back").length_squared() > 0.0:
		return fsm.next("Walk")
