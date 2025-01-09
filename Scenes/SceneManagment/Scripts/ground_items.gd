extends Node2D

@onready var floor_layer: TileMapLayer = $"../FloorLayer"
var tiles: Array[Array] = []
var stockpiles: Array[Stockpile] = []

func init(map_width: int, map_height: int) -> void:
	for y in map_height:
		var row = []
		for x in map_width:
			row.append(null)
		tiles.append(row)
		
func add(tile_pos: Vector2i, item_id: int) -> GroundItem:
	var drop_cords = get_free_tile(tile_pos, item_id)
	if tiles[drop_cords.y][drop_cords.x] == null:
		var item = preload("res://Scenes/GameObjects/Items/ground_item.tscn").instantiate()
		add_child(item)
		item.load_item(item_id)
		var tile_size = floor_layer.tile_set.tile_size
		var x_off = tile_size.x/2
		var y_off = tile_size.y/2
		var pos = Vector2i(drop_cords.x*tile_size.x + x_off, drop_cords.y*tile_size.y + y_off)
		item.global_position = pos
		tiles[drop_cords.y][drop_cords.x] = item
	tiles[drop_cords.y][drop_cords.x].add_count(1)
	return tiles[drop_cords.y][drop_cords.x]
	
func remove(tile_pos: Vector2i) -> bool:
	var item = tiles[tile_pos.y][tile_pos.x]
	if item == null:
		return false
	item.remove_count(1)
	if item.count <= 0:
		item.queue_free()
		tiles[tile_pos.y][tile_pos.x] = null
		return true
	return false

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

func add_stockpile(down_pos: Vector2, up_pos: Vector2) -> void:
	var down_pos_map = Cords.get_map_from_global(down_pos)
	var up_pos_map = Cords.get_map_from_global(up_pos)
	var top_left = Vector2i(mini(down_pos_map.x, up_pos_map.x), mini(down_pos_map.y, up_pos_map.y))
	var bot_right = Vector2i(maxi(down_pos_map.x, up_pos_map.x), maxi(down_pos_map.y, up_pos_map.y))
	var pile = Stockpile.new()
	add_child(pile)
	pile.init(top_left, bot_right)
	stockpiles.append(pile)

func add_to_stockpile(tile_pos: Vector2i, item_id: int) -> void:
	for pile in stockpiles:
		if !pile.is_within_zone(tile_pos):
			continue
		var item = add(tile_pos, item_id)
		pile.add(item)
		
func remove_from_stockpile(tile_pos: Vector2i, item_id: int) -> void:
	var item = tiles[tile_pos.y][tile_pos.x]
	if item.id != item_id:
		print("Item not at tile pos")
		return
	for pile in stockpiles:
		if !pile.is_within_zone(tile_pos):
			continue
		var out = remove(tile_pos)
		if out:
			pile.remove(item)
			
func get_free_stockpile_space() -> Vector2i:
	for pile in stockpiles:
		var free_space = pile.get_free_space()
		if free_space == Vector2i(-1,-1):
			continue
		return free_space
	return Vector2i(-1, -1)

func reserve_stockpile_space(tile_pos: Vector2i, item_id: int) -> void:
	for pile in stockpiles:
		if pile.is_within_zone(tile_pos):
			pile.reserve(tile_pos, item_id)

func get_item_loc(mat: int) -> Vector2i:
	for pile in stockpiles:
		var item_loc = pile.get_item_loc(mat)
		if item_loc == Vector2i(-1,-1):
			continue
		return item_loc
	return Vector2i(-1, -1)

func get_item_with_trait(property: String) -> GroundItem:
	for pile in stockpiles:
		var item = pile.get_item_with_trait(property)
		if item == null:
			continue
		return item
	return null
