extends Node3D

@export var width: int = 1
@export var height: int = 1
@export var depth: int = 1
@export var grid_size: float = 1.0;

@export var iterate_speed: float = 0.0;

@export var wfc_node_scene: PackedScene
@export var wfc_options: Array[Resource]

var wfc_option_instances: Array

func _ready():
	permute_options()
	reset()

func permute_options():
	wfc_option_instances = []
	for o in wfc_options:
		wfc_option_instances.append_array(o.permute_rotations())

func reset():
	clear()

func clear():
	for c in get_children():
		c.queue_free()
		nodes.clear()

func _unhandled_input(event):
	if event.is_action("ui_accept"):
		reset()

var nodes = []

func create_children():
	for i in width:
		for j in height:
			for k in depth:
				var inst = wfc_node_scene.instantiate()
				inst.name = "%s_%s_%s" % [i,j,k]
				inst.options = wfc_option_instances.duplicate()
				inst.grid_position = Vector3(i,j,k)
				add_child(inst)
				inst.global_transform.origin = (Vector3(i,j,k)-Vector3(width,height,depth)/2.0) * grid_size;
				nodes.push_back(inst)

@onready var next_iteration := iterate_speed

func _process(delta):
	if get_child_count() == 0:
		create_children()
		return
	next_iteration -= delta;
	if next_iteration <= 0.0:
		iterate()
		next_iteration = iterate_speed

func get_wfc_node(idx: Vector3) -> Node3D:
	return get_node("%s_%s_%s" % [idx.x, idx.y, idx.z])

func min_entropy_index() -> Vector3:
	var min_idx := 0
	for idx in nodes.size():
		var entropy: int = nodes[idx].entropy()
		if entropy <= 1:
			continue
		if nodes[idx].entropy() < nodes[min_idx].entropy() or nodes[min_idx].entropy() <= 1:
			min_idx = idx
	return nodes[min_idx].grid_position

func iterate():
	var t1 := Time.get_ticks_msec()
	var min_index := min_entropy_index()
	var t2 := Time.get_ticks_msec()
	if get_wfc_node(min_index).entropy() <= 1:
		return
	get_wfc_node(min_index).collapse()
	var t3 := Time.get_ticks_msec()
	propogate(min_index)
	var t4 := Time.get_ticks_msec()
	
	print("%s, %s, %s" % [t2-t1, t3-t2, t4-t3])

const directions = [
	Vector3.UP,
	Vector3.DOWN,
	Vector3.LEFT,
	Vector3.RIGHT,
	Vector3.FORWARD,
	Vector3.BACK
]

func propogate(start_idx: Vector3):
	var visited = {}
	var mutated = {}
	var stack := []
	stack.push_back(start_idx)
	while stack.size() > 0:
		var curr_idx = stack.pop_front()
		var curr_node = get_wfc_node(curr_idx)
		if visited.has(curr_idx):
			visited[curr_idx] += 1
		else:
			visited[curr_idx] = 1
		for dir in directions:
			var look_idx = curr_idx + dir
			if look_idx.x < 0 || look_idx.x >= width || look_idx.y < 0 || look_idx.y >= height || look_idx.z < 0 || look_idx.z >= depth:
				continue
			var changed = get_wfc_node(look_idx).constrain(curr_node, dir)
			if changed and not look_idx in stack:
				stack.push_back(look_idx)
