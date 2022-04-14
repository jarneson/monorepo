extends Node3D

@export_range(0.1, 10.0) var resolution: float = 1.0
@export var extents: Vector3

@export var points: PackedVector3Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func sample(v: Vector3):
	var physics_state = PhysicsServer3D.space_get_direct_state(get_world_3d().space)
	var q = PhysicsPointQueryParameters3D.new()
	q.position = v + global_transform.origin
	if physics_state.intersect_point(q):
		print(v)

func compute():
	print("computing")
	var i = -extents.x
	while i <= extents.x:
		var j = -extents.y
		while j <= extents.y:
			var k = -extents.z
			while k <= extents.z:
				sample(Vector3(i,j,k))
				k += resolution
			j += resolution
		i += resolution

var latch: bool
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if not latch:
		compute()
	latch = true
