extends State
class_name PlaceBuildState

@onready var build_manager: Node2D = %BuildManager
var cur_material = null
var mouse_down = null
var mouse_up = null

func enter() -> void:

	cur_material = 0
	hovering_ui = true
	
func exit() -> void:
	cur_material = null
	
func update(delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		transitioned.emit(self, 'mouseselectstate')
	if Input.is_action_just_pressed('click'):
		mouse_down = get_global_mouse_position()
	if Input.is_action_just_released('click') and !hovering_ui:
		if cur_material == null or mouse_down == null:
			return
		build_manager.order_build(mouse_down, get_global_mouse_position(), cur_material)
	
func physics_update(delta: float) -> void:
	pass
