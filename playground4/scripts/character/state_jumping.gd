extends StateMachineState

@export var gravity = 9.8
@export var air_control = 1.0

func enter(vel):
	fsm.actor.velocity.y = max(fsm.actor.velocity.y + vel, vel)

func physics_process(delta):
	if fsm.actor.is_on_wall() and Input.is_action_pressed("move_sprint"):
		fsm.back()
		fsm.next("Falling")
		return fsm.next("WallRunning")
	
	if Input.is_action_pressed("action_zip"):
		fsm.back()
		fsm.next("Falling")
		return fsm.next("Zip")

	if fsm.actor.velocity.y <= 0.0:
		return fsm.back()
	fsm.actor.velocity.y -= gravity * delta

	var in_dir = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	if in_dir != Vector2.ZERO:
		var dir = fsm.actor.transform.basis * Vector3(in_dir.x, 0.0, in_dir.y)
		dir = dir.normalized()
		var curr = Vector2(fsm.actor.velocity.x, fsm.actor.velocity.z)
		var new = Vector2.from_angle(lerp_angle(curr.angle(), Vector2(dir.x, dir.z).angle(), air_control*delta)) * curr.length()
		if new.length_squared() <= 0:
			new = dir
		fsm.actor.velocity.x = new.x
		fsm.actor.velocity.z = new.y
