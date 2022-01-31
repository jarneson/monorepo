extends NetworkedNode

export var hitpoints: int

onready var last_hitpoints := hitpoints

func _process_data(_delta):
	if hitpoints != last_hitpoints:
		last_hitpoints = hitpoints
		return [hitpoints]
	last_hitpoints = hitpoints
	return null

func take_damage(amount):
	if is_server:
		hitpoints -= amount
	
func _apply_process(data):
	hitpoints = data[0]
	
func _process(_delta):
	if hitpoints <= 0:
		get_parent().queue_free()
