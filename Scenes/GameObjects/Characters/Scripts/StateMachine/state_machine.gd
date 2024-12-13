extends Node2D

@export var init_state: CharacterState
var cur_state
var state_dict = {}

func _ready() -> void:
	for state in self.get_children():
		state_dict[state.name.to_lower()] = state
		state.transitioned.connect(_on_transition)
	if init_state:
		cur_state = init_state
		cur_state.enter()

func _on_transition(state: CharacterState, new_state_name: String) -> void:
	if state != cur_state:
		return
	var new_state = state_dict[new_state_name.to_lower()]
	if cur_state:
		cur_state.exit()
	new_state.enter()
	cur_state = new_state
	
func _process(delta: float) -> void:
	if cur_state:
		cur_state.update(delta)
		
func _physics_process(delta: float) -> void:
	if cur_state:
		cur_state.physics_update(delta)
