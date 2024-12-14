extends Node2D
class_name Pathfinding

@onready var character: CharacterBody2D = $".."
@onready var timer: Timer = $Timer

var astar = AStarGrid2D.new()
var tile_map = null
var cur_path: PackedVector2Array
var path_idx: int

func _ready() -> void:
	tile_map = character.floor_layer
	timer.timeout.connect(_on_timeout)
	init_map()
	
func _process(_delta: float) -> void:
	if tile_map == null:
		tile_map = character.floor_layer
		init_map()
		
func init_map() -> void:
	if tile_map == null:
		return
	character.build_manager.build_placed.connect(_on_map_changed)
	astar.region = Rect2i(0, 0, 18, 10)
	astar.cell_size = Vector2i(32,32)
	astar.set_diagonal_mode(3)
	astar.update()
	var layer_tiles = character.build_layer.get_used_cells()
	for tile in layer_tiles:
		astar.set_point_solid(tile)

func update_path(start: Vector2i, goal: Vector2i) -> void:
	var start_map = get_map_from_global(start)
	var goal_map = get_map_from_global(goal)
	cur_path = astar.get_point_path(start_map, goal_map)
	path_idx = 1
	if cur_path.size() == 1:
		path_idx = 0

func next_node(cur_pos: Vector2i) -> Vector2i:
	if cur_path.is_empty():
		return cur_pos
	if cur_pos.distance_to(cur_path[path_idx]) < 10:
		path_idx += 1
	if path_idx >= cur_path.size():
		path_idx = cur_path.size()-1
	var tile_size = tile_map.tile_set.tile_size
	return cur_path[path_idx] + Vector2(tile_size.x/2, tile_size.y/2)
	
func get_map_from_global(glob: Vector2) -> Vector2:
	var tile_size = tile_map.tile_set.tile_size
	return Vector2i(floor(glob.x/tile_size.x), floor(glob.y/tile_size.y))

func get_global_from_map(map: Vector2i) -> Vector2i:
	var tile_size = tile_map.tile_set.tile_size
	var x_off = tile_size.x/2
	var y_off = tile_size.y/2
	return Vector2(map.x*tile_size.x + x_off, map.y*tile_size.y + y_off)

func _on_map_changed() -> void:
	var layer_tiles = tile_map.get_used_cells()
	for tile in layer_tiles:
		if tile_map.get_cell_tile_data(tile).get_collision_polygons_count(0) != 0:
			astar.set_point_solid(tile)

func _on_timeout() -> void:
	if character.goal_pos == null:
		return
	update_path(character.global_position, character.goal_pos)
