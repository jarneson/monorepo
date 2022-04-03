extends Resource
class_name WFCOption

enum Socket {
	NULL = 0,
	AIR = 1,
	WALL = 2,
	FLOOR = 4,
	LEDGE = 8,
	RAMP = 16,
	MAX = 32,
}

@export var scene: PackedScene
@export var weight: float = 1.0

@export var allow_y_rot_90: bool
@export var allow_y_rot_180: bool
@export var allow_y_rot_270: bool
@export var allow_x_rot_90: bool
@export var allow_x_rot_180: bool
@export var allow_x_rot_270: bool
@export var allow_z_rot_90: bool
@export var allow_z_rot_180: bool
@export var allow_z_rot_270: bool

@export var socket_z_pos: Socket
@export var socket_z_neg: Socket
@export var socket_x_pos: Socket
@export var socket_x_neg: Socket
@export var socket_y_pos: Socket
@export var socket_y_neg: Socket

@export_flags("Air", "Wall", "Floor", "Ledge", "Ramp") var socket_mask_z_pos: int
@export_flags("Air", "Wall", "Floor", "Ledge", "Ramp") var socket_mask_z_neg: int
@export_flags("Air", "Wall", "Floor", "Ledge", "Ramp") var socket_mask_x_pos: int
@export_flags("Air", "Wall", "Floor", "Ledge", "Ramp") var socket_mask_x_neg: int
@export_flags("Air", "Wall", "Floor", "Ledge", "Ramp") var socket_mask_y_pos: int
@export_flags("Air", "Wall", "Floor", "Ledge", "Ramp") var socket_mask_y_neg: int

func permute_rotations() -> Array:
	var out = []
	var rot_weight = weight;
	var permutations = 1;
	permutations += 1 if allow_y_rot_90 else 0
	permutations += 1 if allow_y_rot_180 else 0
	permutations += 1 if allow_y_rot_270 else 0
	permutations += 1 if allow_x_rot_90 else 0
	permutations += 1 if allow_x_rot_180 else 0
	permutations += 1 if allow_x_rot_270 else 0
	permutations += 1 if allow_z_rot_90 else 0
	permutations += 1 if allow_z_rot_180 else 0
	permutations += 1 if allow_z_rot_270 else 0
	rot_weight /= permutations
	if true: # identity
		var inst = Instance.new()
		inst.scene = scene
		inst.weight = rot_weight
		inst.rotation = Vector3(0, 0, 0)
		inst.socket_z_pos = socket_z_pos
		inst.socket_z_neg = socket_z_neg
		inst.socket_x_pos = socket_x_pos
		inst.socket_x_neg = socket_x_neg
		inst.socket_y_pos = socket_y_pos
		inst.socket_y_neg = socket_y_neg
		inst.socket_mask_z_pos = socket_mask_z_pos
		inst.socket_mask_z_neg = socket_mask_z_neg
		inst.socket_mask_x_pos = socket_mask_x_pos
		inst.socket_mask_x_neg = socket_mask_x_neg
		inst.socket_mask_y_pos = socket_mask_y_pos
		inst.socket_mask_y_neg = socket_mask_y_neg
		out.push_back(inst)
	if allow_y_rot_90:
		var inst = Instance.new()
		inst.scene = scene
		inst.weight = rot_weight
		inst.rotation = Vector3(0, 90, 0)
		inst.socket_z_pos = socket_x_neg
		inst.socket_z_neg = socket_x_pos
		inst.socket_x_pos = socket_z_pos
		inst.socket_x_neg = socket_z_neg
		inst.socket_y_pos = socket_y_pos
		inst.socket_y_neg = socket_y_neg
		inst.socket_mask_z_pos = socket_mask_x_neg
		inst.socket_mask_z_neg = socket_mask_x_pos
		inst.socket_mask_x_pos = socket_mask_z_pos
		inst.socket_mask_x_neg = socket_mask_z_neg
		inst.socket_mask_y_pos = socket_mask_y_pos
		inst.socket_mask_y_neg = socket_mask_y_neg
		out.push_back(inst)
	if allow_y_rot_180:
		var inst = Instance.new()
		inst.scene = scene
		inst.weight = rot_weight
		inst.rotation = Vector3(0, 180, 0)
		inst.socket_z_pos = socket_z_neg
		inst.socket_z_neg = socket_z_pos
		inst.socket_x_pos = socket_x_neg
		inst.socket_x_neg = socket_x_pos
		inst.socket_y_pos = socket_y_pos
		inst.socket_y_neg = socket_y_neg
		inst.socket_mask_z_pos = socket_mask_z_neg
		inst.socket_mask_z_neg = socket_mask_z_pos
		inst.socket_mask_x_pos = socket_mask_x_neg
		inst.socket_mask_x_neg = socket_mask_x_pos
		inst.socket_mask_y_pos = socket_mask_y_pos
		inst.socket_mask_y_neg = socket_mask_y_neg
		out.push_back(inst)
	if allow_y_rot_270:
		var inst = Instance.new()
		inst.scene = scene
		inst.weight = rot_weight
		inst.rotation = Vector3(0, 270, 0)
		inst.socket_z_pos = socket_x_pos
		inst.socket_z_neg = socket_x_neg
		inst.socket_x_pos = socket_z_neg
		inst.socket_x_neg = socket_z_pos
		inst.socket_y_pos = socket_y_pos
		inst.socket_y_neg = socket_y_neg
		inst.socket_mask_z_pos = socket_mask_x_pos
		inst.socket_mask_z_neg = socket_mask_x_neg
		inst.socket_mask_x_pos = socket_mask_z_neg
		inst.socket_mask_x_neg = socket_mask_z_pos
		inst.socket_mask_y_pos = socket_mask_y_pos
		inst.socket_mask_y_neg = socket_mask_y_neg
		out.push_back(inst)
	return out

class Instance extends Resource:
	var scene: PackedScene
	var weight: float
	var rotation: Vector3
	var socket_z_pos: Socket
	var socket_z_neg: Socket
	var socket_x_pos: Socket
	var socket_x_neg: Socket
	var socket_y_pos: Socket
	var socket_y_neg: Socket
	var socket_mask_z_pos: int
	var socket_mask_z_neg: int
	var socket_mask_x_pos: int
	var socket_mask_x_neg: int
	var socket_mask_y_pos: int
	var socket_mask_y_neg: int
	
	func instantiate_scene(parent: Node3D):
		var inst = scene.instantiate()
		parent.add_child(inst)
		inst.rotate_x(deg2rad(rotation.x))
		inst.rotate_y(deg2rad(rotation.y))
		inst.rotate_z(deg2rad(rotation.z))
		
