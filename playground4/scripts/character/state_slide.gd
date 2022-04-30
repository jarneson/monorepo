extends StateMachineState

@export var enter_crouch = 2.0
@export var duration = 1.5

var remainder: float
var min_lerp: float
var enter_velocity: Vector3

func enter():
	fsm.actor.standing_shape.disabled = true
	fsm.actor.crouching_shape.disabled = false
	fsm.actor.camera_pivot.transform.origin.y = 0.7
	remainder = duration
	enter_velocity = fsm.actor.velocity
	min_lerp = enter_crouch / enter_velocity.length()
	

func exit():
	fsm.actor.standing_shape.disabled = false
	fsm.actor.crouching_shape.disabled = true
	fsm.actor.camera_pivot.transform.origin.y = 1.7

func physics_process(delta):
	if not fsm.actor.is_on_floor():
		return fsm.next("Falling")
	if remainder <= 0.0:
		# add a replace instead
		fsm.back()
		return fsm.next("Crouch")
	if not Input.is_action_pressed("move_crouch") and not fsm.actor.stand_up_raycast.is_colliding():
		return fsm.back()
	remainder -= delta
	fsm.actor.velocity = enter_velocity * lerp(min_lerp, 1.2, remainder/duration)
