@tool
extends EditorPlugin

const Composer =  preload("res://addons/postprocessing-composer/nodes/postprocessing_composer.gd")
const Layer = preload("res://addons/postprocessing-composer/nodes/layer.gd")

func _enter_tree() -> void:
	add_custom_type("Post-Processing Composer", "Control", Composer, preload("res://addons/postprocessing-composer/plugin_icon.png"))
	add_custom_type("Post-Processing Layer", "Control", Layer, preload("res://addons/postprocessing-composer/plugin_icon.png"))

func _exit_tree() -> void:
	remove_custom_type("Post-Processing Composer")
	remove_custom_type("Post-Processing Layer")
