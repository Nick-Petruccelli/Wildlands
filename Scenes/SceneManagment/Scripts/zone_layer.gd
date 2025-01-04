extends TileMapLayer

var active_stockpiles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func add_stockpile(down_pos: Vector2, up_pos: Vector2) -> void:
	var down_pos_map = Cords.get_map_from_global(down_pos)
	var up_pos_map = Cords.get_map_from_global(up_pos)
	var stockpile_area = []
	var top_left = Vector2i(mini(down_pos_map.x, up_pos_map.x), mini(down_pos_map.y, up_pos_map.y))
	var bot_right = Vector2i(maxi(down_pos_map.x, up_pos_map.x), maxi(down_pos_map.y, up_pos_map.y))
	for y in range(top_left.y, bot_right.y+1):
		var row = []
		for x in range(top_left.x, bot_right.x+1):
			var tile_cords = Vector2i(x,y)
			row.append([tile_cords, -1, null])
			set_cell(tile_cords, 0, Vector2i(0,0))
		stockpile_area.append(row)
	active_stockpiles.append(stockpile_area)

func get_stockpiles() -> Array:
	return active_stockpiles

func put_in_stockpile(loc: Vector2i, item_id: int) -> void:
	for pile in active_stockpiles:
		for row in pile:
			for e in row:
				if e[0] == loc:
					e[1] = item_id
					var item = preload("res://Scenes/GameObjects/ground_item.tscn").instantiate()
					var game = get_tree().root
					game.add_child(item)
					item.load_item(item_id)
					var tile_size = tile_set.tile_size
					var x_off = tile_size.x/2
					var y_off = tile_size.y/2
					var pos = Vector2i(loc.x*tile_size.x + x_off, loc.y*tile_size.y + y_off)
					item.global_position = pos
					e[2] = item

func remove_from_stockpile(loc: Vector2i, item_id: int) -> int:
	var item_out = -1
	for pile in active_stockpiles:
		for row in pile:
			for e in row:
				if e[0] == loc:
					item_out = e[1]
					if item_out == -1:
						return item_out
					e[1] = -1
					e[2].queue_free()
					e[2] = null
					return item_out
	return item_out
	
func get_mat(mat: int) -> Vector2i:
	for pile in active_stockpiles:
		for row in pile:
			for e in row:
				if e[1] == mat:
					return Cords.get_global_from_map(e[0])
	return Vector2i(-1, -1)
