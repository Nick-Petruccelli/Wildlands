extends Plant
class_name WasteTree

func _ready() -> void:
	item_id = 1

func cut_down(character_stats: Dictionary) -> bool:
	var arbory_mod = character_stats["skills"]["arbory"] / 10.0
	health -= 10 + (character_stats["strength"] * arbory_mod)
	print(health)
	if health <= 0:
		var scene_manager = get_tree().get_first_node_in_group("scenemanager")
		scene_manager.add_ground_item(Cords.get_map_from_global(self.global_position), item_id)
		queue_free()
		return true
	return false
