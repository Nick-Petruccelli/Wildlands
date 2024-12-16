extends TileMapLayer

var scene_manager: Node2D

func mine(loc: Vector2i) -> void:
	var map_cords = Cords.get_map_from_global(loc)
	#child 0 is floorlayer
	erase_cell(map_cords)
	scene_manager.add_ground_item(map_cords, 0)
