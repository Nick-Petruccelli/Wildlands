extends TileMapLayer


@export var map_width := 500
@export var map_height := 500
@onready var zone_layer: TileMapLayer = %ZoneLayer
var scene_manager: Node2D

signal build_ordered
signal minning_ordered
signal build_placed
var placed_build = []
var active_stockpiles = []
var build_queue = []
var minning_queue = []

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
	var terrain_id = get_tree().get_first_node_in_group("gamedata").environment_data[tile_id]["terrain_id"]
	var map_cords = Cords.get_map_from_global(cords)
	placed_build[map_cords.y][map_cords.x] = tile_id
	var terain_tiles = []
	for y in range(map_height):
		for x in range(map_width):
			if placed_build[y][x] == tile_id:
				terain_tiles.append(Vector2i(x, y))
	set_cells_terrain_connect(terain_tiles, 0, terrain_id)
	build_placed.emit()
	
func get_next_minning():
	if minning_queue.is_empty():
		return null
	return minning_queue.pop_front()
	
func deconstruct_build(cords: Vector2) -> void:
	var map_cords = Cords.get_map_from_global(cords)
	set_cell(map_cords, 0, Vector2i(0, 0))
	placed_build[map_cords.x][map_cords.y] = -1
	scene_manager.ground_items.add(map_cords, 0)


func open_dir(path: String) -> DirAccess:
	var dir = DirAccess.open(path)
	if dir == null:
		print("ERROR: failed to open directory at: ", path)
	return dir
	
