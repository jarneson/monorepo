extends CharacterBody3D

const MOUSE_SENSITIVITY = 0.002
const SPEED = 15.0
var JUMP_VELOCITY = ProjectSettings.get_setting("physics/3d/default_gravity")/2.0

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var gun = $Pivot/Gun
@onready var camera_pivot = $Pivot

@onready var stand_up_raycast = $StandUpRaycast
@onready var standing_shape = $StandingShape
@onready var crouching_shape = $CrounchingShape

func _ready():
	print("ready")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

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

@export_range(10.0, 100.0) var fov: float = 75.0
@export var gun_offset := Vector3(0.6, -0.4, -1)

func _physics_process(delta):	
	if Input.is_action_pressed("shoot"):
		gun.fire()
	if Input.is_action_pressed("zoom"):
		$Pivot/Camera3D.fov = lerp($Pivot/Camera3D.fov, fov/2.0, delta*10.0)
		gun.position = Vector3(0.0, gun_offset.y, gun_offset.z)
	else:
		$Pivot/Camera3D.fov = lerp($Pivot/Camera3D.fov, fov, delta*10.0)
		gun.position = gun_offset
