@tool
extends SubViewportContainer

@export var remote_camera_path: NodePath
@onready var remote_camera = get_node(remote_camera_path)
@onready var camera = $SubViewport/Camera3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.global_transform = remote_camera.global_transform
