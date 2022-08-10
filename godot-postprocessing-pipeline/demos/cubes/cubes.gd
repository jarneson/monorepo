@tool
extends Node3D

const cube_count = 500
const radius = 25.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if true:
		return
	if get_child_count() == 0:
		make_cubes()

func make_cubes():
	for i in range(cube_count):
		var inst = MeshInstance3D.new()
		inst.mesh = BoxMesh.new()
		inst.mesh.size = Vector3(1,1,1)
		inst.name = "Box_"+str(i)
		add_child(inst)
		var r = radius * sqrt(randf())
		var theta = randf() * 2 * PI
		inst.transform.origin = Vector3(r*cos(theta), randf()*2.0-1.0, r*sin(theta))
		inst.set_owner(get_tree().get_edited_scene_root())
		inst.rotate_x(randf())
		inst.rotate_y(randf())
