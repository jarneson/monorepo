@tool
class_name PostprocessingComposer
extends Control

@export var primary_camera_path: NodePath
@onready var primary_camera = get_node(primary_camera_path)

enum Buffer {
	COLOR,
	DEPTH,
	NORMAL,
}

const buffer_scenes = [
	preload("res://addons/postprocessing-composer/buffers/color/color_buffer.tscn"),
	preload("res://addons/postprocessing-composer/buffers/depth/depth_buffer.tscn"),
	preload("res://addons/postprocessing-composer/buffers/normal/normal_buffer.tscn"),
]

const buffer_names = {
	Buffer.COLOR: "ColorBuffer",
	Buffer.DEPTH: "DepthBuffer",
	Buffer.NORMAL: "NormalBuffer",
}

@onready var existing_buffers = [
	get_node_or_null(buffer_names[Buffer.COLOR]),
	get_node_or_null(buffer_names[Buffer.DEPTH]),
	get_node_or_null(buffer_names[Buffer.NORMAL]),
]

func get_buffer(buf: Buffer):
	if existing_buffers[buf] == null:
		existing_buffers[buf] = SubViewportContainer.new()
		existing_buffers[buf].name = buffer_names[buf]
		existing_buffers[buf].stretch = true
		existing_buffers[buf].set_anchors_preset(Control.PRESET_FULL_RECT)
		add_child(existing_buffers[buf])
		move_child(existing_buffers[buf], 0)
		existing_buffers[buf].set_owner(self.get_owner())
		var bs = buffer_scenes[buf].instantiate()
		bs.name = "Buffer"
		existing_buffers[buf].add_child(bs)
		bs.set_owner(self.get_owner())
		bs.remote_camera_path = bs.get_path_to(primary_camera)
	return existing_buffers[buf].get_node("Buffer")
