extends Button
@onready var place_build_state: PlaceBuildState = %PlaceBuildState
@onready var action_state_machine: Node2D = %ActionStateMachine
@export var tile_id: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("button_up", _on_click)
	
func _on_click() -> void:
	var asm_cur_state = action_state_machine.cur_state
	asm_cur_state.transitioned.emit(asm_cur_state, 'placebuildstate')
