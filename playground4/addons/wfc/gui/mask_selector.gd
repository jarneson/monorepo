@tool
extends GridContainer

signal value_changed

@export var is_selector_not_mask: bool

@onready var buttons := [
	$Button1,
	$Button2,
	$Button3,
	$Button4,
	$Button5,
	$Button6,
	$Button7,
	$Button8,
	$Button9,
	$Button10,
	$Button11,
	$Button12,
	$Button13,
	$Button14,
	$Button15,
	$Button16,
]

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_selector_not_mask:
		var bg = ButtonGroup.new()
		for b in buttons:
			b.button_group = bg
	for b in buttons:
		b.pressed.connect(button_pressed)

func button_pressed():
	value_changed.emit()

func get_value():
	var out = 0
	for b_idx in buttons.size():
		if buttons[b_idx].button_pressed:
			out |= 1 << b_idx
	return out

func set_value(val):
	for b_idx in buttons.size():
		if (1 << b_idx) & val != 0:
			buttons[b_idx].button_pressed = true
