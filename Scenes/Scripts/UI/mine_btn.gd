extends Button


@onready var action_state_machine: Node2D = %ActionStateMachine

func _ready() -> void:
	connect("button_up", _on_click)
	connect("mouse_entered", _on_mouse_enter)
	connect("mouse_exited", _on_mouse_exit)
	
func _on_mouse_enter() -> void:
	action_state_machine.entered_ui.emit()
	
func _on_mouse_exit() -> void:
	action_state_machine.exited_ui.emit()
	
func _on_click() -> void:
	var asm_cur_state = action_state_machine.cur_state
	asm_cur_state.transitioned.emit(asm_cur_state, 'deconstuctionstate')
