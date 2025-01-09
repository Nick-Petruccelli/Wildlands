extends State
class_name PlaceItemState

@onready var scene_manager: Node2D = %SceneManager
var cur_item = null

func enter(args: Array) -> void:
	cur_item = args[0]
	hovering_ui = true
	
func exit() -> void:
	cur_item = null
	
func update(_delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		transitioned.emit(self, 'mouseselectstate', [])
	if Input.is_action_just_released('click') and !hovering_ui:
		if cur_item == null:
			return
		if scene_manager.in_dev_mode:
			scene_manager.ground_items.add(Cords.get_map_from_global(get_global_mouse_position()), cur_item)

func physics_update(_delta: float) -> void:
	pass
