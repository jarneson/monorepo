extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var t1 = Time.get_ticks_msec()
	print(16*16)
	for i in 16*16:
		get_node("Node")
	var t2 = Time.get_ticks_msec()
	print(t2-t1)
	pass # Replace with function body.

