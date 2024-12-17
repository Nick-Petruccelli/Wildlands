extends Node2D
class_name Pathfinding

@onready var character: CharacterBody2D = $".."
@onready var timer: Timer = $Timer

var scene_manager: Node2D = null
var astar = AStarGrid2D.new()
var cur_path: PackedVector2Array
var path_idx: int

func _ready() -> void:
	timer.timeout.connect(_on_timeout)
	init_map()
	
func _process(_delta: float) -> void:
	if scene_manager == null:
		scene_manager = get_tree().get_first_node_in_group("scenemanager")
		init_map()
		
func init_map() -> void:
	if scene_manager == null:
		return
	scene_manager.build_layer.build_placed.connect(_on_map_changed)
	astar.region = Rect2i(0, 0, 100, 100)
	astar.cell_size = Vector2i(16,16)
	astar.set_diagonal_mode(3)
	astar.update()
	var build_tiles = scene_manager.build_layer.get_used_cells()
	var stone_tiles = scene_manager.stone_layer.get_used_cells()
	for tile in build_tiles:
		astar.set_point_solid(tile)
	for tile in stone_tiles:
		astar.set_point_solid(tile)

func update_path(start: Vector2i, goal: Vector2i) -> void:
	var start_map = Cords.get_map_from_global(start)
	var goal_map = Cords.get_map_from_global(goal)
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
	var tile_size = scene_manager.floor_layer.tile_set.tile_size
	return cur_path[path_idx] + Vector2(tile_size.x/2, tile_size.y/2)

func _on_map_changed() -> void:
	var layer_tiles = scene_manager.build_layer.get_used_cells()
	for tile in layer_tiles:
		astar.set_point_solid(tile)

func _on_timeout() -> void:
	if character.goal_pos == null:
		return
	update_path(character.global_position, character.goal_pos)
