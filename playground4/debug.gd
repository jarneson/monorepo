extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	print(Vector3(1.0, 1.0, 0.0).slide(Vector3.RIGHT))
