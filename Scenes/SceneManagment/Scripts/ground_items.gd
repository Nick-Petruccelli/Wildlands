extends Node2D

@onready var floor_layer: TileMapLayer = $"../FloorLayer"
var tiles: Array[Array] = []

func init(map_width: int, map_height: int) -> void:
	for y in map_height:
		var row = []
		for x in map_width:
			row.append(null)
		tiles.append(row)
		
func add(tile_pos: Vector2i, item_id: int) -> Vector2i:
	var drop_cords = get_free_tile(tile_pos, item_id)
	if tiles[drop_cords.y][drop_cords.x] == null:
		var item = preload("res://Scenes/GameObjects/ground_item.tscn").instantiate()
		add_child(item)
		item.load_item(item_id)
		var tile_size = floor_layer.tile_set.tile_size
		var x_off = tile_size.x/2
		var y_off = tile_size.y/2
		var pos = Vector2i(drop_cords.x*tile_size.x + x_off, drop_cords.y*tile_size.y + y_off)
		item.global_position = pos
		tiles[tile_pos.y][tile_pos.x] = item
	tiles[drop_cords.y][drop_cords.x].add_count(1)
	return drop_cords
	
func remove(tile_pos: Vector2i) -> bool:
	var item = tiles[tile_pos.y][tile_pos.x]
	if item == null:
		return false
	item.remove_count(1)
	if item.count <= 0:
		item.queue_free()
		tiles[tile_pos.y][tile_pos.x] = null
	return true

func can_hold(tile_pos: Vector2i, item_id: int) -> bool:
	var item_at_pos = tiles[tile_pos.y][tile_pos.x]
	var item_stack_count = get_tree().get_first_node_in_group("gamedata").item_data[item_id]["stack_count"]
	if item_at_pos == null:
		return true
	if item_at_pos.id != item_id:
		return false
	return item_at_pos.count < item_stack_count
	
func get_free_tile(tile_pos: Vector2i, item_id: int) -> Vector2i:
	if can_hold(tile_pos, item_id):
		return tile_pos
	var layer = 1
	while true:
		for x in range(-layer, layer):
			for y in range(-layer, layer):
				var drop_cords = tile_pos + Vector2i(x, y)
				if can_hold(drop_cords, item_id):
					return drop_cords
			layer += 1
	return Vector2i(-1,-1)
