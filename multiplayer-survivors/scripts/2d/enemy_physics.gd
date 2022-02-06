extends Node

onready var kinematic_body: KinematicBody2D = get_parent()

var direction: Vector2
var speed: float = 250.0

var velocity: Vector2
func _physics_process(delta: float):
	velocity = lerp(velocity, direction * speed, min(delta*10, 1.0))
	velocity = kinematic_body.move_and_slide(velocity)
