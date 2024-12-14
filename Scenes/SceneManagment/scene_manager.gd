extends Node2D
@onready var game: Node2D = $".."
@onready var floor_layer: TileMapLayer = %FloorLayer


var items_on_ground = {}
var colonists = []
var stock_piels = []
	
func add_ground_item(map_cords, item_id):
	items_on_ground[item_id] = map_cords
	var item = preload("res://Scenes/Wall.tscn").instantiate()
	game.add_child(item)
	var tile_size = floor_layer.tile_set.tile_size
	var x_off = tile_size.x/2
	var y_off = tile_size.y/2
	var pos = Vector2(map_cords.x*tile_size.x + x_off, map_cords.y*tile_size.y + y_off)
	item.global_position = pos
	
func get_item(item_id: int) -> Vector2i:
	for item in items_on_ground:
		if item == item_id:
			return Cords.get_global_from_map(items_on_ground[item])
	return Vector2i(-1,-1)
