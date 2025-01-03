extends TileMapLayer

var scene_manager: Node2D
signal stone_removed
var tile_data: Array = []

func _ready() -> void:
	var map_size = $"../FloorLayer".get_used_rect().size
	for y in range(map_size.y):
		tile_data.append([])
		for x in range(map_size.x):
			tile_data[y].append(0)
	for cord in get_used_cells():
		tile_data[cord.y][cord.x] = 100


func mine(loc: Vector2i, character_stats: Dictionary) -> bool:
	var map_cords = Cords.get_map_from_global(loc)
	var mining_mod = character_stats["skills"]["mining"] / 10.0
	tile_data[map_cords.y][map_cords.x] -= 10 + (character_stats["strength"] * mining_mod)
	print("stone_loc: ", map_cords, " stone_dur: ", tile_data[map_cords.y][map_cords.x])
	if tile_data[map_cords.y][map_cords.x] <= 0:
		erase_cell(map_cords)
		stone_removed.emit(map_cords)
		scene_manager.add_ground_item(map_cords, 0)
		return true
	return false
