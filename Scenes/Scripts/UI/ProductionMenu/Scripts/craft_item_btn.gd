extends Button
class_name CraftItemBtn

var data: Dictionary = {}
var station: ProductionStation = null

func init() -> void:
	connect("button_up", _on_click)

func _on_click() -> void:
	var build_mats = data["craft_mats"]
	for mat_name in build_mats:
		var mat_id = int(build_mats[mat_name][0])
		var mat_count = int(build_mats[mat_name][1])
		var scene_manager = get_tree().get_first_node_in_group('scenemanager')
		scene_manager.order_work("Craft", [station, data])
