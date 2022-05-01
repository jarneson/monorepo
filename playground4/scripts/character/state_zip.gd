extends StateMachineState

@export var delay: float = 0.25

var zip_velocity: Vector3

var elapsed: float
func enter():
	# is camera -z a little off.. i dunno?
	zip_velocity = -fsm.actor.camera.global_transform.basis.z * fsm.actor.velocity.length()
	fsm.actor.velocity = Vector3.ZERO
	elapsed = 0.0

func physics_process(delta):
	if not Input.is_action_pressed("action_zip"):
		return fsm.back()
	if elapsed > delay:
		fsm.actor.velocity = zip_velocity
	else:
		elapsed += delta
