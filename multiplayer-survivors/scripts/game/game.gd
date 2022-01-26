extends Spatial
var _nul

export(PackedScene) var world_scene

func _ready():
	_nul = $Network.connect("network_ready", self, "_network_ready")
	$Network.initialize()
	
func _network_ready():
	print("network ready")
	add_child(world_scene.instance())
