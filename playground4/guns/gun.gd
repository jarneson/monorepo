extends Node3D

const ModUtils = preload("res://guns/resources/mod_utils.gd")

@export var bullet_pool_node_path: NodePath
@onready var bullet_pool = get_node(bullet_pool_node_path)

const body_scenes = [
	preload("res://guns/bodies/ar-brow.tscn"),
	preload("res://guns/bodies/ar-chin.tscn"),
	preload("res://guns/bodies/ar-fancy.tscn"),
	preload("res://guns/bodies/ar-grip.tscn"),
	preload("res://guns/bodies/ar-tube.tscn"),
	preload("res://guns/bodies/smg-fancy.tscn"),
	preload("res://guns/bodies/smg-tube.tscn"),
]

const barrel_scenes = [
	preload("res://guns/barrels/double.tscn"),
	preload("res://guns/barrels/grenade.tscn"),
	preload("res://guns/barrels/long-accurate.tscn"),
	preload("res://guns/barrels/long-triple.tscn"),
	preload("res://guns/barrels/long-wide.tscn"),
	preload("res://guns/barrels/short-narrow.tscn"),
	preload("res://guns/barrels/short-triple.tscn"),
	preload("res://guns/barrels/short-wide.tscn"),
]

const grip_scenes = [
	preload("res://guns/grips/big-simple.tscn"),
	preload("res://guns/grips/bubble-grip.tscn"),
	preload("res://guns/grips/bubble-heavy.tscn"),
	preload("res://guns/grips/curvy-flat.tscn"),
	preload("res://guns/grips/long-heavy.tscn"),
	preload("res://guns/grips/p90ish.tscn"),
	preload("res://guns/grips/pistol-simple.tscn"),
	preload("res://guns/grips/pistoleer.tscn"),
	preload("res://guns/grips/sleek.tscn"),
	preload("res://guns/grips/weird.tscn"),
]

const stock_scenes = [
	preload("res://guns/stocks/basic.tscn"),
	preload("res://guns/stocks/block.tscn"),
	preload("res://guns/stocks/bright.tscn"),
	preload("res://guns/stocks/bubbly.tscn"),
	preload("res://guns/stocks/comfortable.tscn"),
	preload("res://guns/stocks/curvy.tscn"),
	preload("res://guns/stocks/small-block.tscn"),
	preload("res://guns/stocks/small.tscn"),
	preload("res://guns/stocks/stylish.tscn"),
	preload("res://guns/stocks/techy.tscn"),
]

@export var mods: Array:
	set(v):
		mods = v
		compute_stats()

func randomize_gun():
	var existing = get_node_or_null("Body")
	if existing != null:
		existing.name = "Body_Old"
		existing.queue_free()
	
	var body = body_scenes[randi()%body_scenes.size()].instantiate()
	body.name = "Body"
	add_child(body)
	
	var barrel = barrel_scenes[randi()%barrel_scenes.size()].instantiate()
	barrel.name = "Barrel"
	body.get_node("BarrelAnchor").add_child(barrel)
	
	var grip = grip_scenes[randi()%grip_scenes.size()].instantiate()
	grip.name = "Grip"
	body.get_node("GripAnchor").add_child(grip)
	
	var stock = stock_scenes[randi()%stock_scenes.size()].instantiate()
	stock.name = "Stock"
	body.get_node("StockAnchor").add_child(stock)
	
	mods = [ModUtils.random_mod()]

func _unhandled_input(evt: InputEvent):
	if evt is InputEventKey and !evt.pressed and evt.keycode == KEY_F1:
		randomize_gun()

func _ready():
	randomize_gun()

var lifetime: float = 3.0
var damage: int
var damage_range: float
var speed: float
var size: float
var ricochets: int
var ricochet_damage: float
var damage_falloff: float
var homing_speed: float
var homing_distance: float
var explosion_radius: float
var pierce: int
var shatter: int
var shatter_damage: float
var toxin: float
var toxin_duration: float

var spread: float
var bullets_per_shot: int
var cooldown: float

@onready var remaining_cooldown = 0.0;
func fire():
	if remaining_cooldown > 0:
		return
	for i in bullets_per_shot:
		bullet_pool.make_bullet(
			$Body/BarrelAnchor.global_transform.origin-global_transform.basis.z,
			(global_transform.basis*Vector3(
				randf_range(-spread, spread),
				randf_range(-spread, spread),
				-1
			)).normalized()*speed,
			lifetime,
			damage,
			damage_range,
			speed,
			size,
			ricochets,
			ricochet_damage,
			damage_falloff,
			homing_speed,
			homing_distance,
			explosion_radius,
			pierce,
			shatter,
			shatter_damage,
			toxin,
			toxin_duration
		)
	remaining_cooldown = cooldown

func compute_stats():
	cooldown = ModUtils.compute_cooldown(mods)
	bullets_per_shot = ModUtils.compute_bullets(mods)
	speed = ModUtils.compute_speed(mods)
	ricochets = ModUtils.compute_ricochet(mods)
	spread = ModUtils.compute_spread(mods)
	size = ModUtils.compute_size(mods)

var camera_offset: Vector3
func _physics_process(delta):
	remaining_cooldown = max(remaining_cooldown-delta, 0.0)

