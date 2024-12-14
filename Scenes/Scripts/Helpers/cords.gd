extends Node

@export var tile_size: int = 32

func get_map_from_global(glob: Vector2) -> Vector2:
	return Vector2i(floor(glob.x/tile_size), floor(glob.y/tile_size))

func get_global_from_map(map: Vector2i) -> Vector2i:
	var off = tile_size/2
	return Vector2(map.x*tile_size + off, map.y*tile_size + off)
