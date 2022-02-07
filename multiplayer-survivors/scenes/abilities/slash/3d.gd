extends Particles

const Angles = preload("res://scripts/utils/angles.gd")
const Vectors = preload("res://scripts/utils/vectors.gd")

var projectile_2d

func _ready():
	projectile_2d.connect("ending", self, "_on_ending")
	set_rotation(Vector3(0, Angles.Angle2To3(projectile_2d.rotation), 0))
	var mat = get("draw_pass_1").material
	var pl = PlaneMesh.new()
	pl.size = Vector2(projectile_2d.width * Vectors.pixels_to_meters, 0.5)
	pl.material = mat
	set("draw_pass_1", pl)

func _on_ending():
	emitting = false
	yield(get_tree().create_timer(1.0), "timeout")
	get_parent().queue_free()
