extends Node2D


@export var map_width := 500
@export var map_height := 500
@onready var floor_layer: TileMapLayer = %FloorLayer
@onready var zone_layer: TileMapLayer = %ZoneLayer
@onready var scene_manager: Node2D = %SceneManager
signal build_ordered
signal minning_ordered
signal build_placed
var placed_build = []
var active_stockpiles = []
var build_queue = []
var minning_queue = []
var tile_map = {0: Vector2i(1,1)}

func _ready() -> void:
	init_map()

func _process(_delta: float) -> void:
	pass

func init_map() -> void:
	placed_build = []
	for y in range(map_height):
		var row = []
		for x in range(map_width):
			row.append(-1)
		placed_build.append(row)



func order_build(down_pos: Vector2, up_pos: Vector2, tile_id: int) -> void:
	var map_cords = Cords.get_map_from_global(up_pos)
	if placed_build[map_cords.x][map_cords.y] != -1:
		return
	build_queue.push_back([up_pos, tile_id])
	build_ordered.emit()
		
func get_next_build() -> Array:
	if build_queue.is_empty():
		return []
	return build_queue.pop_front()

func order_deconstuction(down_pos: Vector2, up_pos: Vector2) -> void:
	var down_pos_map = Cords.get_map_from_global(down_pos)
	var up_pos_map = Cords.get_map_from_global(up_pos)
	var top_left = Vector2i(mini(down_pos_map.x, up_pos_map.x), mini(down_pos_map.y, up_pos_map.y))
	var bot_right = Vector2i(maxi(down_pos_map.x, up_pos_map.x), maxi(down_pos_map.y, up_pos_map.y))
	for y in range(top_left.y, bot_right.y+1):
		for x in range(top_left.x, bot_right.x+1):
			if placed_build[x][y] == -1:
				continue
			minning_queue.push_back(Cords.get_global_from_map(Vector2i(x,y)))
	minning_ordered.emit()
	
func place_build(cords: Vector2, tile_id: int) -> void:
	var selected_obj = tile_map[tile_id]
	var map_cords = Cords.get_map_from_global(cords)
	floor_layer.set_cell(map_cords, 0, selected_obj)
	placed_build[map_cords.x][map_cords.y] = tile_id
	build_placed.emit()
	
func get_next_minning():
	if minning_queue.is_empty():
		return null
	return minning_queue.pop_front()
	
func deconstruct_build(cords: Vector2) -> void:
	var map_cords = Cords.get_map_from_global(cords)
	floor_layer.set_cell(map_cords, 0, Vector2i(0, 0))
	placed_build[map_cords.x][map_cords.y] = -1
	scene_manager.add_ground_item(map_cords, 0)

func add_stockpile(down_pos: Vector2, up_pos: Vector2) -> void:
	var down_pos_map = Cords.get_map_from_global(down_pos)
	var up_pos_map = Cords.get_map_from_global(up_pos)
	var stockpile_area = []
	var top_left = Vector2i(mini(down_pos_map.x, up_pos_map.x), mini(down_pos_map.y, up_pos_map.y))
	var bot_right = Vector2i(maxi(down_pos_map.x, up_pos_map.x), maxi(down_pos_map.y, up_pos_map.y))
	for y in range(top_left.y, bot_right.y+1):
		var row = []
		for x in range(top_left.x, bot_right.x+1):
			var tile_cords = Vector2i(x,y)
			row.append([tile_cords, 0])
			zone_layer.set_cell(tile_cords, 0, Vector2i(0,0))
		stockpile_area.append(row)
	active_stockpiles.append(stockpile_area)
	
func get_mat(mat: int) -> Vector2i:
	for pile in active_stockpiles:
		for row in pile:
			for e in row:
				if e[1] == mat:
					return Cords.get_global_from_map(e[0])
	return Vector2i(-1, -1)
