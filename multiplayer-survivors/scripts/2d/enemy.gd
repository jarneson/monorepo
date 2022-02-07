extends KinematicBody2D

signal removed

onready var physics = $Physics

var hitpoints: int
var experience: int

func die():
	Singletons.experience.add(experience)
	emit_signal("removed")
	queue_free()

func _process(_delta):
	if hitpoints <= 0:
		die()
		return
	var nearest = get_tree().get_nodes_in_group("players")
	if nearest:
		physics.direction = (nearest[0].global_position - global_position).normalized()
	else:
		physics.direction = Vector2.ZERO

func take_damage(amount: int):
	hitpoints -= amount
