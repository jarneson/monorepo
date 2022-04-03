@tool
extends Panel

var editor_interface: EditorInterface
var option: WFCOption

@onready var scene_preview: TextureRect = $H/L/ScenePreview
@onready var scene_name_label: Label = $H/L/SceneName

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_name_label.text = option.scene.resource_path.get_file()
	if editor_interface:
		print("fetching preview for ", option.scene.resource_path)
		print(ClassDB.is_parent_class(option.scene.get_class(), "PackedScene"))
		editor_interface.get_resource_previewer().queue_resource_preview(option.scene.resource_path, self, "set_scene_preview", null)

func set_scene_preview(path: String, preview: Texture2D, thumbnail: Texture2D, userdata):
	print("got preview")
	scene_preview.texture = preview

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
