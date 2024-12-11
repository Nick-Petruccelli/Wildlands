extends Node2D


@export var map_width := 500
@export var map_height := 500
@onready var tile_map_layer: TileMapLayer = %TileMapLayer
signal build_ordered
var placed_build = []
var build_queue = []
var tile_map = {0: Vector2i(1,1)}

func _ready() -> void:
	init_map()

func _process(delta: float) -> void:
	pass

func init_map() -> void:
	placed_build = []
	for y in range(map_height):
		var row = []
		for x in range(map_width):
			row.append(-1)
		placed_build.append(row)

func place_build(cords: Vector2i, tile_id: int) -> void:
	var selected_obj = tile_map[tile_id]
	var tile_size = tile_map_layer.tile_set.tile_size
	var map_cords = Vector2i(floor(cords.x/tile_size.x), floor(cords.y/tile_size.y))
	tile_map_layer.set_cell(map_cords, 0, selected_obj)
	print("tile place at: ", cords)

func order_build(cords: Vector2i, tile_id: int) -> void:
	if placed_build[cords.x][cords.y] != -1:
		return
	build_queue.push_back([cords, tile_id])
	build_ordered.emit()
	var tile_size = tile_map_layer.tile_set.tile_size
	print("build_ordered at: ",Vector2i(floor(cords.x/tile_size.x), floor(cords.y/tile_size.y)))
	
func get_next_build() -> Array:
	if build_queue.is_empty():
		return []
	return build_queue.pop_front()
