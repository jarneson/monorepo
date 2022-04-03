@tool
extends Panel

signal deleted

const MaskSelector = preload("res://addons/wfc/gui/mask_selector.gd")

var editor_interface: EditorInterface
var option: WFCOption

@onready var scene_preview: TextureRect = $H/L/ScenePreview
@onready var scene_name_label: Label = $H/L/SceneName

@onready var weight_input: SpinBox = $H/L/Weight
@onready var rotation_checkboxes = [
	[
		$"H/L/XRotations/90",
		$"H/L/XRotations/180",
		$"H/L/XRotations/270"
	],
	[
		$"H/L/YRotations/90",
		$"H/L/YRotations/180",
		$"H/L/YRotations/270"
	],
	[
		$"H/L/ZRotations/90",
		$"H/L/ZRotations/180",
		$"H/L/ZRotations/270"
	]
]

@onready var sockets := [
	$H/R/posx/HBoxContainer/MaskSelector,
	$H/R/negx/HBoxContainer/MaskSelector,
	$H/R/posy/HBoxContainer/MaskSelector,
	$H/R/negy/HBoxContainer/MaskSelector,
	$H/R/posz/HBoxContainer/MaskSelector,
	$H/R/negz/HBoxContainer/MaskSelector,
]

@onready var masks := [
	$H/R/posx/HBoxContainer/MaskSelector2,
	$H/R/negx/HBoxContainer/MaskSelector2,
	$H/R/posy/HBoxContainer/MaskSelector2,
	$H/R/negy/HBoxContainer/MaskSelector2,
	$H/R/posz/HBoxContainer/MaskSelector2,
	$H/R/negz/HBoxContainer/MaskSelector2,
]

@onready var delete_button: Button = $H/M/Delete

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_name_label.text = option.scene.resource_path.get_file()
	if editor_interface:
		editor_interface.get_resource_previewer().queue_resource_preview(option.scene.resource_path, self, "set_scene_preview", null)
	parse_resource()
	for s in sockets:
		s.value_changed.connect(update_resource)
	for m in masks:
		m.value_changed.connect(update_resource)
	for cb_arr in rotation_checkboxes:
		for cb in cb_arr:
			cb.pressed.connect(update_resource)
	weight_input.value_changed.connect(update_resource_var_1)
	delete_button.pressed.connect(delete_pressed)

func set_scene_preview(path: String, preview: Texture2D, thumbnail: Texture2D, userdata):
	# broken for packe scenes idk why yet. maybe a bug in 4.0?
	print("got preview")
	scene_preview.texture = preview

func delete_pressed():
	deleted.emit()

func update_resource_var_1(_var):
	update_resource()

func update_resource():
	option.weight = weight_input.value
	option.allow_x_rot_90 = rotation_checkboxes[0][0].button_pressed
	option.allow_x_rot_180 = rotation_checkboxes[0][1].button_pressed
	option.allow_x_rot_270 = rotation_checkboxes[0][2].button_pressed
	option.allow_y_rot_90 = rotation_checkboxes[1][0].button_pressed
	option.allow_y_rot_180 = rotation_checkboxes[1][1].button_pressed
	option.allow_y_rot_270 = rotation_checkboxes[1][2].button_pressed
	option.allow_z_rot_90 = rotation_checkboxes[2][0].button_pressed
	option.allow_z_rot_180 = rotation_checkboxes[2][1].button_pressed
	option.allow_z_rot_270 = rotation_checkboxes[2][2].button_pressed
	option.socket_x_pos = sockets[0].get_value()
	option.socket_x_neg = sockets[1].get_value()
	option.socket_y_pos = sockets[2].get_value()
	option.socket_y_neg = sockets[3].get_value()
	option.socket_z_pos = sockets[4].get_value()
	option.socket_z_neg = sockets[5].get_value()
	option.socket_mask_x_pos = masks[0].get_value()
	option.socket_mask_x_neg = masks[1].get_value()
	option.socket_mask_y_pos = masks[2].get_value()
	option.socket_mask_y_neg = masks[3].get_value()
	option.socket_mask_z_pos = masks[4].get_value()
	option.socket_mask_z_neg = masks[5].get_value()

func parse_resource():
	weight_input.value = option.weight
	rotation_checkboxes[0][0].button_pressed = option.allow_x_rot_90
	rotation_checkboxes[0][1].button_pressed = option.allow_x_rot_180
	rotation_checkboxes[0][2].button_pressed = option.allow_x_rot_270
	rotation_checkboxes[1][0].button_pressed = option.allow_y_rot_90
	rotation_checkboxes[1][1].button_pressed = option.allow_y_rot_180
	rotation_checkboxes[1][2].button_pressed = option.allow_y_rot_270
	rotation_checkboxes[2][0].button_pressed = option.allow_z_rot_90
	rotation_checkboxes[2][1].button_pressed = option.allow_z_rot_180
	rotation_checkboxes[2][2].button_pressed = option.allow_z_rot_270
	sockets[0].set_value(option.socket_x_pos)
	sockets[1].set_value(option.socket_x_neg)
	sockets[2].set_value(option.socket_y_pos)
	sockets[3].set_value(option.socket_y_neg)
	sockets[4].set_value(option.socket_z_pos)
	sockets[5].set_value(option.socket_z_neg)
	masks[0].set_value(option.socket_mask_x_pos)
	masks[1].set_value(option.socket_mask_x_neg)
	masks[2].set_value(option.socket_mask_y_pos)
	masks[3].set_value(option.socket_mask_y_neg)
	masks[4].set_value(option.socket_mask_z_pos)
	masks[5].set_value(option.socket_mask_z_neg)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
