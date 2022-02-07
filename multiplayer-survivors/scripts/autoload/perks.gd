extends Node

var perks: Array

const path = "res://resources/perks"

func _ready():
	var dir = Directory.new()
	dir.open(path)
	
	dir.list_dir_begin()
	var filename = dir.get_next()
	
	while(filename != ""):
		if filename != "." and filename != "..":
			perks.push_back(load(path + "/" + filename))
		filename = dir.get_next()
	dir.list_dir_end()
