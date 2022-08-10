@tool
extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready():
	debug_draw = Viewport.DEBUG_DRAW_NORMAL_BUFFER


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	debug_draw = Viewport.DEBUG_DRAW_NORMAL_BUFFER
