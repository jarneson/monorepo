@tool
class_name PostprocessingLayer
extends Control

enum Buffer {
	COLOR,
	DEPTH,
	NORMAL,
}

@export var buffer: Buffer = Buffer.COLOR :
	get:
		return buffer
	set(value):
		buffer = value
		print("set_buffer: ", value)

@export var shaders: Array[ShaderMaterial] : 
	get:
		return _shaders_storage
	set(value):
		_shaders_storage = value
		create_tree()

@export var _shaders_storage: Array[ShaderMaterial]

@onready var composer = get_parent()

@export var root_shader: ShaderMaterial : 
	get:
		return root_shader
	set(value):
		root_shader = value
		create_tree()

func drop_tree():
	for c in get_children():
		c.queue_free()

func create_tree():
	if not Engine.is_editor_hint():
		return
	drop_tree()
	
	# prepare buffer rect
	var buf = composer.get_buffer(buffer)
	var sv = SubViewportContainer.new()
	sv.stretch = true
	sv.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(sv)
	sv.set_owner(self.get_owner())
	sv.material = root_shader
	
	var vp = SubViewport.new()
	sv.add_child(vp)
	vp.set_owner(self.get_owner())
	
	var next_parent = self
	var tr = TextureRect.new()
	
	tr.set_anchors_preset(Control.PRESET_FULL_RECT)
	var tex = ViewportTexture.new()
	tex.viewport_path = self.get_owner().get_path_to(buf)
	tr.texture = tex
	vp.add_child(tr)
	tr.set_owner(self.get_owner())
	
	# add shaders
	for s in shaders:
		var bb = BackBufferCopy.new()
		vp.add_child(bb)
		bb.set_owner(self.get_owner())
		bb.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
		
		var cl = CanvasLayer.new()
		bb.add_child(cl)
		cl.set_owner(self.get_owner())
		
		var cr = ColorRect.new()
		cr.set_anchors_preset(Control.PRESET_FULL_RECT)
		cr.material = s
		cl.add_child(cr)
		cr.set_owner(self.get_owner())
