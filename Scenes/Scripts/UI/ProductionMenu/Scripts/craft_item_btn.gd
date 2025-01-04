extends Button
class_name CraftItemBtn

var data: Dictionary = {}
var station: ProductionStation = null

func init() -> void:
	connect("button_up", _on_click)

func _on_click() -> void:
	print("craft clicked")
	var build_mats = data["craft_mats"]
	for mat_name in build_mats:
		var mat_id = int(build_mats[mat_name][0])
		var mat_count = int(build_mats[mat_name][1])
		if station.inventory.count(mat_id) < mat_count:
			print("Not Enough materials to craft ", data["name"])
			return
		remove_mats_from_inventory(mat_id, mat_count)
		station.inventory.append(data["id"])

func remove_mats_from_inventory(mat_id: int, mat_count: int) -> void:
	for i in range(mat_count):
		station.inventory.erase(mat_id)
