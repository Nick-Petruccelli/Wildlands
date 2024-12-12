extends Node2D


@export var map_width := 500
@export var map_height := 500
@onready var tile_map_layer: TileMapLayer = %TileMapLayer
@onready var stock_pile_layer: TileMapLayer = $"../StockPileLayer"
@onready var scene_manager: Node2D = %SceneManager
signal build_ordered
signal minning_ordered
var placed_build = []
var active_stockpiles = []
var build_queue = []
var minning_queue = []
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

func get_map_from_global(glob: Vector2) -> Vector2:
	var tile_size = tile_map_layer.tile_set.tile_size
	return Vector2i(floor(glob.x/tile_size.x), floor(glob.y/tile_size.y))

func order_build(down_pos: Vector2, up_pos: Vector2, tile_id: int) -> void:
	var map_cords = get_map_from_global(up_pos)
	if placed_build[map_cords.x][map_cords.y] != -1:
		return
	build_queue.push_back([up_pos, tile_id])
	build_ordered.emit()
		
func get_next_build() -> Array:
	if build_queue.is_empty():
		return []
	return build_queue.pop_front()

func order_minning(down_pos: Vector2, up_pos: Vector2) -> void:
	var map_cords = get_map_from_global(up_pos)
	if placed_build[map_cords.x][map_cords.y] == -1:
		return
	minning_queue.push_back(up_pos)
	minning_ordered.emit()
	
func place_build(cords: Vector2, tile_id: int) -> void:
	var selected_obj = tile_map[tile_id]
	var map_cords = get_map_from_global(cords)
	tile_map_layer.set_cell(map_cords, 0, selected_obj)
	placed_build[map_cords.x][map_cords.y] = tile_id
	
func get_next_minning():
	if minning_queue.is_empty():
		return null
	return minning_queue.pop_front()
	
func mine_build(cords: Vector2) -> void:
	var map_cords = get_map_from_global(cords)
	tile_map_layer.set_cell(map_cords, 0, Vector2i(0, 0))
	placed_build[map_cords.x][map_cords.y] = -1
	scene_manager.add_ground_item(map_cords, 0)

func add_stockpile(down_pos: Vector2, up_pos: Vector2) -> void:
	var down_pos_map = get_map_from_global(down_pos)
	var up_pos_map = get_map_from_global(up_pos)
	var stockpile_area = []
	var top_left = Vector2i(mini(down_pos_map.x, up_pos_map.x), mini(down_pos_map.y, up_pos_map.y))
	var bot_right = Vector2i(maxi(down_pos_map.x, up_pos_map.x), maxi(down_pos_map.y, up_pos_map.y))
	for y in range(top_left.y, bot_right.y+1):
		var row = []
		for x in range(top_left.x, bot_right.x+1):
			var tile_cords = Vector2i(x,y)
			row.append(tile_cords)
			stock_pile_layer.set_cell(tile_cords, 0, Vector2i(0,0))
		stockpile_area.append(row)
	active_stockpiles.append(stockpile_area)
	
