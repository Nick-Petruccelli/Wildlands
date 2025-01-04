extends State
class_name ZonePlacingState

@onready var build_layer: TileMapLayer = $"../../SceneManager/BuildLayer"
@onready var zone_layer: TileMapLayer = $"../../SceneManager/ZoneLayer"
var cur_zone_type = null
var down_pos = null

func enter(args: Array) -> void:
	cur_zone_type = args[0]
	down_pos = null
	hovering_ui = true
	
func exit() -> void:
	cur_zone_type = null
	
func update(_delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		transitioned.emit(self, 'mouseselectstate', [])
	if Input.is_action_just_pressed("click"):
		down_pos = get_global_mouse_position()
	if Input.is_action_just_released("click") and !hovering_ui:
		if down_pos == null:
			return
		#TODO this needs to eventualy work for more than just stockpile but that comes later
		zone_layer.add_stockpile(down_pos, get_global_mouse_position())
	
func physics_update(_delta: float) -> void:
	pass
