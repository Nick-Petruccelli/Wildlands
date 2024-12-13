extends Node2D

@export var init_state: State
var cur_state
var state_dict = {}
signal entered_ui
signal exited_ui

func _ready() -> void:
	for state in self.get_children():
		state_dict[state.name.to_lower()] = state
		state.transitioned.connect(_on_transition)
	if init_state:
		cur_state = init_state
		cur_state.enter()
	connect("entered_ui", _on_entered_ui)
	connect("exited_ui", _on_exited_ui)

func _on_transition(state: State, new_state_name: String) -> void:
	if state != cur_state:
		return
	var new_state = state_dict[new_state_name.to_lower()]
	if cur_state:
		cur_state.exit()
	new_state.enter()
	cur_state = new_state
	
func _process(delta: float) -> void:
	print(cur_state.hovering_ui)
	if cur_state:
		cur_state.update(delta)
		
func _physics_process(delta: float) -> void:
	if cur_state:
		cur_state.physics_update(delta)

func _on_entered_ui() -> void:
	cur_state.hovering_ui = true

func _on_exited_ui() -> void:
	cur_state.hovering_ui = false
