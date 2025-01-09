extends State
class_name HaulState


var down_pos = null

func enter(args: Array) -> void:
	down_pos = null
	hovering_ui = true
	
func exit() -> void:
	down_pos = null
	
func update(_delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		transitioned.emit(self, 'mouseselectstate')
	if Input.is_action_just_pressed("click"):
		down_pos = get_global_mouse_position()
	if Input.is_action_just_released("click") and !hovering_ui:
		if down_pos == null:
			return
		haul_in_area(down_pos, get_global_mouse_position())
	
func physics_update(_delta: float) -> void:
	pass

func haul_in_area(down_pos: Vector2i, up_pos: Vector2i) -> void:
	var scene_manager = get_tree().get_first_node_in_group('scenemanager')
	var ground_items = scene_manager.ground_items
	var selected_tiles = get_selected_tiles(down_pos, up_pos)
	for tile in selected_tiles:
		if ground_items.is_in_stockpile(tile):
			continue
		if ground_items.get_item_at(tile) == null:
			continue
		scene_manager.order_work("Haul", [tile, ground_items.get_item_at(tile).id])

func get_selected_tiles(down_pos: Vector2i, up_pos: Vector2i) -> Array[Vector2i]:
	var down_pos_map = Cords.get_map_from_global(down_pos)
	var up_pos_map = Cords.get_map_from_global(up_pos)
	var top_left = Vector2i(mini(down_pos_map.x, up_pos_map.x), mini(down_pos_map.y, up_pos_map.y))
	var bot_right = Vector2i(maxi(down_pos_map.x, up_pos_map.x), maxi(down_pos_map.y, up_pos_map.y))
	var out: Array[Vector2i] = []
	for y in range(top_left.y, bot_right.y+1):
		for x in range(top_left.x, bot_right.x+1):
			out.push_back(Vector2i(x,y))
	return out
