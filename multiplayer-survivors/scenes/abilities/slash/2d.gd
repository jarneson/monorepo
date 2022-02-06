extends Area2D

signal ending

var direction: Vector2

var lifetime = 1.0
var speed = 1024.0

func end():
	emit_signal("ending")
	queue_free()

func _physics_process(delta):
	lifetime -= delta
	if lifetime < 0.0:
		end()
		return
	global_position += direction*speed*delta

func _on_Slash_body_entered(body):
	print(body)
