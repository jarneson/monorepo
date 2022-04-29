extends Node
class_name StateMachine

var state: Object
var _state_args: Array
var states_cache: Dictionary
var history: Array
@export var is_active: bool = false

func _ready():
	states_cache = {}
	for c in get_children():
		states_cache[c.name] = c
	history = []
	if is_active:
		start()

func start():
	is_active = true
	var initial_state = initialize()
	if initial_state:
		next(initial_state)
	else:
		next(get_child(0).name)

func _enter_state(s, args = []):
	state = s
	_state_args = args
	state.fsm = self
	if state.has_method("enter"):
		state.callv("enter", args)

func initialize():
	pass

func next(new_state, args = []):
	if state:
		history.append([state.name, _state_args])
		state.exit()
	_enter_state(states_cache[new_state], args)

func back():
	if history.size() > 0:
		state.exit()
		var last = history.pop_back()
		_enter_state(states_cache[last[0]], last[1])
	else:
		print("called back on empty history")

# game loop
func _process(delta):
	if is_active and state and state.has_method("process"):
		state.process(delta)

func _physics_process(delta):
	if is_active and state and state.has_method("physics_process"):
		state.physics_process(delta)

func _input(event):
	if is_active and state and state.has_method("input"):
		state.input(event)

func _unhandled_input(event):
	if is_active and state and state.has_method("unhandled_input"):
		state.unhandled_input(event)
