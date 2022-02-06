extends Node2D

onready var enemies = $Enemies
onready var players = $Players
onready var projectiles = $Projectiles

func start():
	players.start()
