@tool
extends EditorPlugin

const GUI = preload("res://addons/wfc/gui/gui.tscn")
var gui

func _enter_tree():
	gui = GUI.instantiate()
	gui.editor_interface = get_editor_interface()
	get_editor_interface().get_editor_main_control().add_child(gui)
	_make_visible(false)

func _make_visible(vis):
	gui.visible = vis

func _exit_tree():
	gui.queue_free()

func _has_main_screen():
	return true

func _get_plugin_name():
	return "WFC"

func _get_plugin_icon():
	return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")
