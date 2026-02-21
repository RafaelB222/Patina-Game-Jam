extends Node

var initial_behavior_state: State
@export var parent_entity: Node

var current_state : State
var states : Dictionary = {}

func _ready():
	if parent_entity:
		print("the parent_entity of the state machine is... ", parent_entity)
		for child in get_children():
			if child is State:
				states[child.name.to_lower()] = child
				print("The name of the child state being added is: ", child.name.to_lower())
				child.Transitioned.connect(on_child_transition)

		if parent_entity.has_signal("stats_ready"):
			parent_entity.stats_ready.connect(_initialise_state_machine)
		else:
			call_deferred("_initialise_state_machine")
		

func _initialise_state_machine() -> void:
	var initial_behavior_name = parent_entity.initial_behavior_state

	if initial_behavior_name:
		print("The initial behavior state of the enemy is: ", initial_behavior_name)
		initial_behavior_state = states[parent_entity.initial_behavior_state]
	else:
		print("parent_entity had no initial behavior state")
	
	if initial_behavior_state:
		print("Entering the behavior state for: ", initial_behavior_name)
		initial_behavior_state.Enter()
		current_state = initial_behavior_state
	else:
		print("no initial behavior state to enter.")

	

func _process(delta):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state
