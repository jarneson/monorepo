@tool
extends SubViewport

var is_ready: bool

@export var remote_camera_path: NodePath :
	set(value):
		remote_camera_path = value
		if is_ready:
			remote_camera = get_node(value)
var remote_camera: Camera3D
@onready var camera = $Camera3D

func _ready():
	is_ready = true
	if not remote_camera_path.is_empty():
		remote_camera = get_node(remote_camera_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if remote_camera:
		camera.global_transform = remote_camera.global_transform
	else:
		print("no remote camera at: ", remote_camera_path)
