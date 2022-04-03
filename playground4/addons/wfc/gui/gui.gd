@tool
extends VBoxContainer

const OptionPanel = preload("res://addons/wfc/gui/option_panel.tscn")

var editor_interface: EditorInterface

@onready var new_set_button: Button = $Toolbar/M/H/NewSet
@onready var load_set_button: Button = $Toolbar/M/H/LoadSet
@onready var loaded_set_label: Label = $Toolbar/M/H/LoadedSet
@onready var add_scene_button: Button = $Toolbar/M/H/AddScene
@onready var options_container: Container = $Scroll/Container

var current_set: WFCOptionSet:
	set(v):
		current_set = v
		refresh_gui()

func _ready():
	new_set_button.pressed.connect(new_set_pressed)
	load_set_button.pressed.connect(load_set_pressed)
	add_scene_button.pressed.connect(add_scene_pressed)

func new_set_pressed():
	var fd = FileDialog.new()
	fd.set_filters(PackedStringArray(["*.tres,*.res; Resources"]))
	add_child(fd)
	fd.popup_centered(Vector2(480, 600))
	var file_name = await fd.file_selected
	fd.queue_free()
	var res = WFCOptionSet.new()
	ResourceSaver.save(file_name, res)
	current_set = load(file_name)

func load_set_pressed():
	var fd = FileDialog.new()
	fd.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	fd.set_filters(PackedStringArray(["*.tres,*.res; Resources"]))
	add_child(fd)
	fd.popup_centered(Vector2(480, 600))
	var file_name = await fd.file_selected
	fd.queue_free()
	current_set = load(file_name)

var scene_dir_memo: String = "res://"
func add_scene_pressed():
	var fd = FileDialog.new()
	fd.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	fd.current_dir = scene_dir_memo
	fd.set_filters(PackedStringArray(["*.tscn; Scenes"]))
	add_child(fd)
	fd.popup_centered(Vector2(480, 600))
	var file_name = await fd.file_selected
	scene_dir_memo = file_name.get_base_dir()
	fd.queue_free()
	var opt = WFCOption.new()
	opt.scene = load(file_name)
	current_set.options.push_back(opt)
	refresh_gui()

func refresh_gui():
	for c in options_container.get_children():
		c.queue_free()
	if current_set == null:
		loaded_set_label.text = "None"
		add_scene_button.visible = false
	loaded_set_label.text = current_set.resource_path
	add_scene_button.visible = true
	print(current_set)
	for opt in current_set.options:
		var p = OptionPanel.instantiate()
		p.option = opt
		p.editor_interface = editor_interface
		options_container.add_child(p)
	
