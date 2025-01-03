extends Panel

var shown_panel = null

func _ready() -> void:
	connect("mouse_entered", _on_mouse_enter)
	connect("mouse_exited", _on_mouse_exit)
	
func _on_mouse_enter() -> void:
	var action_state_machine = get_tree().get_first_node_in_group("actionstatemachine")
	action_state_machine.entered_ui.emit()
	
func _on_mouse_exit() -> void:
	var action_state_machine = get_tree().get_first_node_in_group("actionstatemachine")
	action_state_machine.exited_ui.emit()

func show_panel(panel) -> void:
	if shown_panel == null:
		panel.visible = true
		shown_panel = panel
		return
	if panel.name.to_lower() == shown_panel.name.to_lower():
		shown_panel.visible = false
		shown_panel = null
		return
	shown_panel.visible = false
	shown_panel = panel
	panel.visible = true
