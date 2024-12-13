extends State
class_name DeconstuctionState

@onready var build_manager: Node2D = %BuildManager
var down_pos = null

func enter() -> void:
	down_pos = null
	hovering_ui = true
	
func exit() -> void:
	down_pos = null
	
func update(delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		transitioned.emit(self, 'mouseselectstate')
	if Input.is_action_just_pressed("click"):
		down_pos = get_global_mouse_position()
	if Input.is_action_just_released("click") and !hovering_ui:
		if down_pos == null:
			return
		build_manager.order_deconstuction(down_pos, get_global_mouse_position())
	
func physics_update(delta: float) -> void:
	pass
