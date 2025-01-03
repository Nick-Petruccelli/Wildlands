extends Node2D
@onready var game: Node2D = $".."
@onready var floor_layer: TileMapLayer = $FloorLayer
@onready var zone_layer: TileMapLayer = $ZoneLayer
@onready var build_layer: TileMapLayer = $BuildLayer
@onready var stone_layer: TileMapLayer = $StoneLayer
@onready var plants: Node2D = $Plants
@onready var characters: Node2D = $Characters


var items_on_ground = {}
var colonists = []
var work_queue = []
var stock_piels = []
@onready var map_size = floor_layer.get_used_rect()
@onready var query_work_timer: Timer = $Query_Work_Timer

func _ready():
	add_to_group("scenemanager")
	for character in characters.get_children():
		character.scene_manager = self
		character.work_done.connect(_on_character_work_done)
	for node in get_children():
		if node is not TileMapLayer:
			continue
		if "scene_manager" in node:
			node.scene_manager = self
	query_work_timer.timeout.connect(query_work)
	
func _on_character_work_done(character: Character) -> void:
	character.get_work_order(work_queue)

func order_work(task: String, args: Array):
	work_queue.push_back([task, args])
	query_work()
	
func query_work() -> void:
	if work_queue.is_empty():
		return
	for colonist in characters.get_children():
		colonist.get_work_order(work_queue)

func add_ground_item(map_cords: Vector2i, item_id: int):
	var item = preload("res://Scenes/Wall.tscn").instantiate()
	game.add_child(item)
	var tile_size = floor_layer.tile_set.tile_size
	var x_off = tile_size.x/2
	var y_off = tile_size.y/2
	var pos = Vector2i(map_cords.x*tile_size.x + x_off, map_cords.y*tile_size.y + y_off)
	item.global_position = pos
	if !items_on_ground.has(item_id):
		items_on_ground[item_id] = []
	items_on_ground[item_id].append([map_cords, item])
	
func remove_ground_item(map_cords: Vector2i, item_id: int) -> void:
	for item in items_on_ground[item_id]:
		if item[0] == map_cords:
			items_on_ground[item_id].erase(item)
			item[1].queue_free()
			return

func get_item(item_id: int) -> Vector2i:
	for item in items_on_ground:
		if item == item_id:
			return Cords.get_global_from_map(items_on_ground[item])
	return Vector2i(-1,-1)
