extends Node3D

@export var width: int = 1
@export var height: int = 1
@export var depth: int = 1
@export var grid_size: float = 1.0;

@export var iterate_speed: float = 0.0;

@export var wfc_node_scene: PackedScene
@export var wfc_options: Array[Resource]

func _ready():
	reset()

func reset():
	clear()

func clear():
	for c in get_children():
		c.queue_free()

func _unhandled_input(event):
	if event.is_action("ui_accept"):
		reset()

func create_children():
	for i in width:
		for j in height:
			for k in depth:
				var inst = wfc_node_scene.instantiate()
				inst.name = "%s_%s_%s" % [i,j,k]
				inst.options = wfc_options.duplicate()
				add_child(inst)
				inst.global_transform.origin = (Vector3(i,j,k)-Vector3(width,height,depth)/2.0) * grid_size;

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
	var min := Vector3.ZERO
	for i in width:
		for j in height:
			for k in depth:
				var entropy: int = get_wfc_node(Vector3(i,j,k)).entropy()
				if entropy <= 1:
					continue
				if get_wfc_node(Vector3(i,j,k)).entropy() < get_wfc_node(min).entropy() or get_wfc_node(min).entropy() <= 1:
					min = Vector3(i,j,k)
	return min

func iterate():
	var min_index := min_entropy_index()
	if get_wfc_node(min_index).entropy() <= 1:
		return
	get_wfc_node(min_index).collapse()
	propogate(min_index)

const directions = [
	Vector3.UP,
	Vector3.DOWN,
	Vector3.LEFT,
	Vector3.RIGHT,
	Vector3.FORWARD,
	Vector3.BACK
]

func propogate(start_idx: Vector3):
	var stack := []
	stack.push_back(start_idx)
	while stack.size() > 0:
		var curr_idx = stack.pop_front()
		var curr_node = get_wfc_node(curr_idx)
		for dir in directions:
			var look_idx = curr_idx + dir
			
			if look_idx.x < 0 || look_idx.x >= width || look_idx.y < 0 || look_idx.y >= height || look_idx.z < 0 || look_idx.z >= depth:
				continue
			var changed = get_wfc_node(look_idx).constrain(dir, curr_node.sockets(dir))
			if changed and not look_idx in stack:
				stack.push_back(look_idx)
