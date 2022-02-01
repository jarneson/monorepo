extends NetworkedNode

var experience: int
var level: int = 1

func _ready():
	Singletons.experience = self

onready var last_experience: int = experience
func _process_data(_delta):
	var ret = null
	if experience >= next_level_amount():
		experience -= next_level_amount()
		level += 1
		ret = [experience, level]
	elif experience != last_experience:
		ret = [experience, level]
		
	last_experience = experience
	return ret

puppet func _apply_process(data):
	experience = data[0]
	level = data[1]

func next_level_amount():
	return 10 * pow(1.25, level-1)
	
func increase(amount):
	if is_server:
		experience += amount
