extends CharacterBody3D

@export var target_node_path: NodePath


@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var detection_radius: Area3D = $DetectionRadius

var speed = 4.0

func _ready():
	nav_agent.velocity_computed.connect(_velocity_computed)
	nav_agent.set_target_location(global_transform.origin + Vector3.UP*nav_agent.agent_height_offset
)

func _velocity_computed(v: Vector3):
	velocity = v
	move_and_slide()

func _physics_process(_delta):
	if detection_radius.get_overlapping_bodies():
		var t = detection_radius.get_overlapping_bodies()[0]
		if nav_agent.get_target_location().distance_squared_to(t.global_transform.origin) > 1.0:
			nav_agent.agent_height_offset = randf_range(-12.5, -2.5)
			nav_agent.set_target_location(t.global_transform.origin)

	if nav_agent.is_navigation_finished():
		return
	velocity = (nav_agent.get_next_location() - global_transform.origin).normalized() * speed
	nav_agent.set_velocity(velocity)
