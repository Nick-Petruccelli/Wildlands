extends Node
class_name Stockpile

var items: Dictionary = {}
var top_left: Vector2i
var bot_right: Vector2i

func init(t_left: Vector2i, b_right: Vector2i) -> void:
	var zone_layer = get_tree().get_first_node_in_group("scenemanager").zone_layer
	top_left = t_left
	bot_right = b_right
	for y in range(top_left.y, bot_right.y+1):
		for x in range(top_left.x, bot_right.x+1):
			zone_layer.set_cell(Vector2i(x,y), 0, Vector2i(0,0))
			items[Vector2i(x,y)] = null

func add(ground_item: GroundItem) -> void:
	var loc = Cords.get_map_from_global(ground_item.global_position)
	items[loc] = ground_item

func remove(ground_item: GroundItem) -> void:
	var loc = Cords.get_map_from_global(ground_item.global_position)
	items[loc] = null
	
func get_item_loc(item_id: int) -> Vector2i:
	for y in range(top_left.y, bot_right.y+1):
		for x in range(top_left.x, bot_right.x+1):
			var item = items[Vector2i(x,y)]
			if item == null:
				continue
			if item is int and item == item_id:
				return Vector2i(x, y)
			if item is int:
				continue
			if item.id != item_id:
				continue
			return Vector2i(x, y)
	return Vector2i(-1,-1)
	
func get_free_space() -> Vector2i:
	for y in range(top_left.y, bot_right.y+1):
		for x in range(top_left.x, bot_right.x+1):
			var item = items[Vector2i(x,y)]
			if item == null:
				return Vector2i(x,y)
	return Vector2i(-1, -1)

func reserve(tile_pos: Vector2i, item_id: int) -> void:
	items[tile_pos] = item_id

func has(item_id: int) -> bool:
	return get_item_loc(item_id) != Vector2i(-1,-1)

func is_within_zone(tile_pos: Vector2i) -> bool:
	var out = true
	out = out and top_left.x <= tile_pos.x
	out = out and tile_pos.x <= bot_right.x
	out = out and top_left.y <= tile_pos.y
	out = out and tile_pos.y <= bot_right.y
	return out
