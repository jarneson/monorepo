extends Node3D

@export var bullet_scene: PackedScene
@export var cooldown: float
@export var count: int = 5

func _unhandled_input(event):
	if event.is_action("shoot"):
		fire()

var remaining_cooldown: float = 0.0
func _process(delta):
	remaining_cooldown -= delta

func fire():
	if remaining_cooldown > 0.0:
		return
	remaining_cooldown = cooldown
	for i in count:
		var inst = bullet_scene.instantiate()
		get_parent().get_parent().get_parent().add_child(inst)
		inst.global_transform = get_parent().global_transform
		inst.global_transform.origin = $Position3D.global_transform.origin
		inst.linear_velocity = get_parent().global_transform.basis.z * -250.0
		inst.linear_velocity = inst.linear_velocity.rotated(get_parent().global_transform.basis.y, randf_range(-PI/12.0,PI/12.0))
		inst.linear_velocity = inst.linear_velocity.rotated(get_parent().global_transform.basis.x, randf_range(-PI/12.0,PI/12.0))
	
