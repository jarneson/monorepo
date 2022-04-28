extends StateMachine

@onready var actor = get_parent()

func _ready():
	super()

func _physics_process(delta):
	super(delta)
	actor.move_and_slide()
