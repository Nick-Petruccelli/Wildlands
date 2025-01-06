extends Node2D
class_name Farms

func tile_planted(tile) -> bool:
	for crop in get_children():
		if crop.map_pos == tile:
			return true
	return false

func plant(tile: Vector2i, crop_id: int) -> void:
	var crop = preload("res://Scenes/Environment/Plants/Crop.tscn").instantiate()
	crop.global_position = Cords.get_global_from_map(tile)
	crop.crop_id = crop_id
	crop.map_pos = tile
	crop.time_planted = Time.get_ticks_msec()
	add_child(crop)
	crop.init()
	self.add_child(crop)

func harvest(tile: Vector2i) -> void:
	var crops = get_children()
	var crop: Crop = null
	for c in crops:
		if c.map_pos == tile:
			crop = c
			break
	if crop == null:
		return
	crop.harvest()
	
