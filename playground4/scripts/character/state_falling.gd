extends StateMachineState

@export var gravity = 9.8

func physics_process(delta):
	print("fall")
	if fsm.actor.is_on_floor():
		fsm.back()
		return
	fsm.actor.velocity.y -= gravity * delta
