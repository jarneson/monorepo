extends Spatial

var enemy_2d

func _ready():
	enemy_2d.connect("removed", self, "_on_removed")

func _on_removed():
	get_parent().queue_free()
