extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", _on_mouse_enter)
	connect("mouse_exited", _on_mouse_exit)
	
func _on_mouse_enter() -> void:
	var action_state_machine = get_tree().get_first_node_in_group("actionstatemachine")
	action_state_machine.entered_ui.emit()
	
func _on_mouse_exit() -> void:
	var action_state_machine = get_tree().get_first_node_in_group("actionstatemachine")
	action_state_machine.exited_ui.emit()
