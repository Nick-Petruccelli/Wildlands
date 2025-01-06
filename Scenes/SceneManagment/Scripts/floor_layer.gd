extends TileMapLayer

var farm_land: Array[Vector2i] = []

func set_floor_tile(pos: Vector2i, terrain_set: int, terrain_id: int) -> void:
	var used_tiles = get_used_cells()
	var terrain_tiles = [pos]
	for tile in used_tiles:
		var tile_data = get_cell_tile_data(tile)
		if terrain_set == tile_data.terrain_set and terrain_id == tile_data.terrain:
			terrain_tiles.append(tile)
	set_cells_terrain_connect(terrain_tiles, terrain_set, terrain_id)
