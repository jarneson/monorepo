@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("StateMachine", "Node3D", preload("./machine.gd"), preload("./icons/machine.svg"))
	add_custom_type("StateMachineState", "Node3D", preload("./state.gd"), preload("./icons/state.svg"))

func _exit_tree():
	remove_custom_type("StateMachine")
	remove_custom_type("StateMachineState")
