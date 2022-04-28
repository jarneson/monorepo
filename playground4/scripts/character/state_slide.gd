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
	print("slide")
