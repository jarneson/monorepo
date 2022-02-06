extends Spatial

onready var world_2d = $Physics/World2D

func _ready():
	world_2d.start()
