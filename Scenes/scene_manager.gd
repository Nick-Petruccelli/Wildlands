extends Node2D
@onready var game: Node2D = $".."
@onready var tile_map_layer: TileMapLayer = %TileMapLayer


var items_on_ground = {}
var colonists = []

func add_ground_item(map_cords, item_id):
	items_on_ground[item_id] = map_cords
	var item = preload("res://Scenes/Wall.tscn").instantiate()

	print(item)
	game.add_child(item)
	var tile_size = tile_map_layer.tile_set.tile_size
	var item_width = item.get_child(0).texture.get_width()
	var item_height = item .get_child(0).texture.get_height()
	var x_off = tile_size.x/2
	var y_off = tile_size.y/2
	var pos = Vector2(map_cords.x*tile_size.x + x_off, map_cords.y*tile_size.y + y_off)
	print(pos)
	item.global_position = pos
