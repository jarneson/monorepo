extends Spatial

const World2d= preload("res://scripts/2d/world_2d.gd")

export(NodePath) var world_2d_path: String
onready var world_2d: World2d = get_node(world_2d_path)

onready var enemies = $Enemies
onready var players = $Players
onready var projectiles = $Projectiles

func _ready():
	enemies.enemies_2d = world_2d.enemies
	players.players_2d = world_2d.players
	projectiles.projectiles_2d = world_2d.projectiles
