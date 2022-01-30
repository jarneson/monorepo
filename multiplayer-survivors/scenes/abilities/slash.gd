extends Spatial

export var angle: float = 45
export var duration: float = 0.3

func _ready():
	self.transform = self.transform.rotated(Vector3.UP, -deg2rad(angle))

onready var lifetime = duration

func _physics_process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
	else:
		self.transform.basis = self.transform.basis.rotated(Vector3.UP, deg2rad(delta*2*angle/duration))

func _on_Area_body_entered(body):
	print(body)
