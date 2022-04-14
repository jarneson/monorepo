extends NavigationRegion3D

@onready var mesh_instance = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var nm = NavigationMesh.new()
	nm.create_from_mesh(mesh_instance.mesh)
	navmesh = nm

