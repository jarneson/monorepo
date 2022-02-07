extends KinematicBody2D

onready var physics = $Physics

var last_direction: Vector2 = Vector2.DOWN

var perks = []

const base_speed = 500.0

func _ready():
	Singletons.follow_node_2d = self
	physics.speed = 500.0

func _process(_delta):
	if Singletons.inputs.input:
		last_direction = Singletons.inputs.input.normalized()
		physics.direction = last_direction
	else:
		physics.direction = Vector2.ZERO

var reduced_cooldown: int
var projectile_speed: int
var duration: int
var area: int
var run_speed: int

func refresh_stats():
	reduced_cooldown = 0
	projectile_speed = 0
	duration = 0
	area = 0
	run_speed = 0
	for p in perks:
		reduced_cooldown += p.affix.reduced_cooldown
		projectile_speed += p.affix.projectile_speed
		duration += p.affix.duration
		area += p.affix.area
		run_speed += p.affix.run_speed
	physics.speed = base_speed * (1.0 + float(run_speed)/100.0)

func add_perk(p):
	perks.push_back(p)
	refresh_stats()
