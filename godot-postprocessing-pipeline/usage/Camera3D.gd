extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var t: float
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	global_transform.origin.y = 9 + 5*sin(t)
	pass
