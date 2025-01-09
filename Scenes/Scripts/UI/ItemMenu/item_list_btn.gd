extends Button
class_name  ItemListBtn

var data: Dictionary = {}

@onready var action_state_machine: Node2D = %ActionStateMachine

func _ready() -> void:
	connect("button_up", _on_click)

func _on_click() -> void:
	if action_state_machine == null:
		action_state_machine = get_tree().get_first_node_in_group("actionstatemachine")
	var asm_cur_state = action_state_machine.cur_state
	asm_cur_state.transitioned.emit(asm_cur_state, 'placeitemstate', [data['id']])
