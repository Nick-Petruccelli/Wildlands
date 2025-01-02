extends TileMapLayer

var scene_manager: Node2D
signal stone_removed

func mine(loc: Vector2i) -> void:
	var map_cords = Cords.get_map_from_global(loc)
	erase_cell(map_cords)
	stone_removed.emit()
	scene_manager.add_ground_item(map_cords, 0)
