extends Node2D

signal ending

var player

var width: int = 32
var direction: Vector2

var damage: int = 100

var lifetime = 1.0
var speed = 512.0

func calculate_stats():
	speed *= 1.0 + float(player.projectile_speed)/100.0
	lifetime *= 1.0 + float(player.duration)/100.0
	width *= 1.0 + float(player.area)/100.0

func end():
	emit_signal("ending")
	queue_free()

func _physics_process(delta):
	lifetime -= delta
	if lifetime < 0.0:
		end()
		return
	var original = global_position
	global_position += direction*speed*delta
	scan_hits(original, global_position)

func scan_hits(original: Vector2, new: Vector2):
	var rect = RectangleShape2D.new()
	rect.extents = Vector2(original.distance_to(new), width)/2.0
	var q = Physics2DShapeQueryParameters.new()
	q.collision_layer = 1 << 8
	q.set_shape(rect)
	q.transform = Transform2D(rotation, new+(original-new)/2)
	var res = Physics2DServer.space_get_direct_state(get_world_2d().space).intersect_shape(q, 128)
	for r in res:
		r.collider.take_damage(damage)

