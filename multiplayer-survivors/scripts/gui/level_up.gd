extends CenterContainer

onready var option_1 = $P/V/Option1
onready var option_2 = $P/V/Option2
onready var option_3 = $P/V/Option3

var player

var opts = [null, null, null]

func _ready():
	var perks = Perks.perks.duplicate()
	for i in range(3):
		var idx = randi() % perks.size()
		opts[i] = perks[idx]
		perks.remove(idx)
		
	option_1.get_node("Label").text = "%s\n%s" % [opts[0].name, opts[0].affix.to_string()]
	option_2.get_node("Label").text = "%s\n%s" % [opts[1].name, opts[1].affix.to_string()]
	option_3.get_node("Label").text = "%s\n%s" % [opts[2].name, opts[2].affix.to_string()]

func _enter_tree():
	get_tree().paused = true
	
func _exit_tree():
	get_tree().paused = false

func close():
	queue_free()

func _on_Option1_pressed():
	player.add_perk(opts[0])
	close()

func _on_Option2_pressed():
	player.add_perk(opts[1])
	close()

func _on_Option3_pressed():
	player.add_perk(opts[2])
	close()
