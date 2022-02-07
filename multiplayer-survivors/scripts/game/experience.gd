extends Node

signal level_up

var experience: int
var level: int = 1

func _ready():
	Singletons.experience = self

func _process(_delta):
	if experience >= next_level_amount():
		experience -= next_level_amount()
		level += 1
		emit_signal("level_up")

func next_level_amount():
	return 10 * pow(1.25, level-1)

func add(amount: int):
	experience += amount
