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
			row.append([tile_cords, 0])
			set_cell(tile_cords, 0, Vector2i(0,0))
		stockpile_area.append(row)
	active_stockpiles.append(stockpile_area)

func get_mat(mat: int) -> Vector2i:
	for pile in active_stockpiles:
		for row in pile:
			for e in row:
				if e[1] == mat:
					return Cords.get_global_from_map(e[0])
	return Vector2i(-1, -1)
