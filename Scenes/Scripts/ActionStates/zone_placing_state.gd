extends State
class_name ZonePlacingState

@onready var build_manager: Node2D = %BuildManager
var cur_zone_type = null
var down_pos = null

func enter() -> void:
	cur_zone_type = null
	down_pos = null
	
func exit() -> void:
	cur_zone_type = null
	
func update(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		down_pos = get_global_mouse_position()
	if Input.is_action_just_released("click"):
		if down_pos == null:
			return
		#TODO this needs to eventualy work for more than just stockpile but that comes later
		build_manager.add_stockpile(down_pos, get_global_mouse_position())
	
func physics_update(delta: float) -> void:
	pass
