extends Node2D
@onready var game: Node2D = $".."
@onready var floor_layer: TileMapLayer = $FloorLayer
@onready var zone_layer: TileMapLayer = $ZoneLayer
@onready var build_layer: TileMapLayer = $BuildLayer
@onready var stone_layer: TileMapLayer = $StoneLayer
@onready var plants: Node2D = $Plants
@onready var animals: Node2D = $Animals
@onready var constructions: Node2D = $Constructions
@onready var characters: Node2D = $Characters
@onready var farms: Node2D = $Plants/Farms


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

func add_ground_item(map_cords: Vector2i, item_id: int) -> Vector2i:
	var drop_cords = get_free_tile(map_cords)
	var item = preload("res://Scenes/GameObjects/ground_item.tscn").instantiate()
	game.add_child(item)
	item.load_item(item_id)
	var tile_size = floor_layer.tile_set.tile_size
	var x_off = tile_size.x/2
	var y_off = tile_size.y/2
	var pos = Vector2i(drop_cords.x*tile_size.x + x_off, drop_cords.y*tile_size.y + y_off)
	item.global_position = pos
	if !items_on_ground.has(item_id):
		items_on_ground[item_id] = []
	items_on_ground[item_id].append([drop_cords, item])
	return drop_cords
	
func is_tile_empty(map_cords: Vector2i) -> bool:
	for item_type in items_on_ground:
		for loc in items_on_ground[item_type]:
			if loc[0] == map_cords:
				return false
	return true
	
func get_free_tile(map_cords: Vector2i) -> Vector2i:
	if is_tile_empty(map_cords):
		return map_cords
	var layer = 1
	for i in range(5):
		for x in range(-layer, layer):
			for y in range(-layer, layer):
				var drop_cords = map_cords + Vector2i(x, y)
				if is_tile_empty(drop_cords):
					return drop_cords
			layer += 1
	return Vector2i(-1,-1)

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

func build(cords: Vector2i, build_id: int) -> void:
	var build_data = get_tree().get_first_node_in_group("gamedata").environment_data[build_id]
	if build_data["type"].to_lower() == "structure":
		build_layer.place_build(cords, build_id)
	else:
		var item = preload("res://Scenes/Environment/production_station.tscn").instantiate()
		constructions.add_child(item)
		item.load_data(build_id)
		var offset = Vector2i((item.sprite_2d.texture.get_size().x/2)-8, 0)
		item.global_position = cords + offset
	
