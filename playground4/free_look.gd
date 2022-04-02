extends Node3D

const MOUSE_SENSITIVITY = 0.002
const SPEED = 15.0

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		$Pivot.rotate_x(-event.relative.y*MOUSE_SENSITIVITY)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
	if event.is_action_released("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			print("unlock")
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			print("lock")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	var direction = ($Pivot.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	position += direction * SPEED * delta;
