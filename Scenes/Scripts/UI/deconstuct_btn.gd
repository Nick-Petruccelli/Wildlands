extends Button


@onready var action_state_machine: Node2D = %ActionStateMachine

func _ready() -> void:
	connect("button_up", _on_click)
	
func _on_click() -> void:
	var asm_cur_state = get_tree().get_first_node_in_group("actionstatemachine").cur_state
	asm_cur_state.transitioned.emit(asm_cur_state, 'deconstuctionstate', [])
