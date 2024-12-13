extends Button

@onready var action_state_machine: Node2D = %ActionStateMachine

func _ready() -> void:
	connect("button_up", _on_click)

func _on_click() -> void:
	var asm_cur_state = action_state_machine.cur_state
	asm_cur_state.transitioned.emit(asm_cur_state, 'zoneplacingstate')
