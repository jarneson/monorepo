extends MarginContainer

@export var actor_node_path: NodePath
@onready var actor = get_node(actor_node_path)

@export var movement_node_path: NodePath
@onready var movement_node = get_node(movement_node_path)

@onready var debug_movement_state = $H/L/MovementState
@onready var position_velocity = $H/L/PositionVelocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	debug_movement_state.text = movement_node.state.name
	position_velocity.text = str(actor.global_transform.origin) + "\n" + \
		str(actor.velocity) + "\n" + \
		str(actor.velocity.length()) + "\n" + \
		str(Vector2(actor.velocity.x, actor.velocity.z).length()) + "\n" + \
		"on floor: " + str(actor.is_on_floor()) + "\n" + \
		"on wall : " + str(actor.is_on_wall())
