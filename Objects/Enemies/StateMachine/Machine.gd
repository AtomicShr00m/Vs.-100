extends Node
class_name StateMachine

var states:={}
onready var current:State

func _ready():
	for state in get_children():
		if state is State:
			if !is_instance_valid(current):
				current=state
			states[state.name.to_lower()]=state
			state.connect("transit",self,'transition_to')
			state.pawn=get_parent()
	current.open()

func _process(delta):
	current.update(delta)

func get_state():
	return current.name.to_lower()

func transition_to(state, new_state_name):
	if state!=current:
		return
	var new_state=states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current:
		current.close()
	new_state.open()
	current = new_state
