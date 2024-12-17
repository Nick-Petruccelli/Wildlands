extends Plant
class_name WasteTree

func _ready() -> void:
	item_id = 1

func cut_down() -> void:
	var scene_manager = get_tree().get_first_node_in_group("scenemanager")
	scene_manager.add_ground_item(Cords.get_map_from_global(self.global_position), item_id)
	queue_free()
