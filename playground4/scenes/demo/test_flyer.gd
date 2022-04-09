extends CharacterBody3D

@export var target_node_path: NodePath
@onready var target_node: Node3D = get_node(target_node_path)

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var speed = 4.0

func _ready():
	nav_agent.set_target_location(target_node.global_transform.origin)

func _physics_process(delta):
	print(nav_agent.get_next_location())
	velocity = (nav_agent.get_next_location() - global_transform.origin).normalized() * speed
	move_and_slide()
	pass
