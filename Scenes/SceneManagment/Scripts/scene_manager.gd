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
@onready var ground_items: Node2D = $GroundItems

var items_on_ground = {}
var colonists = []
var work_queue = []
var stock_piels = []
@onready var map_size = floor_layer.get_used_rect().size
@onready var query_work_timer: Timer = $Query_Work_Timer
var in_dev_mode = false

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
	ground_items.init(map_size.x, map_size.y)
	
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
	
