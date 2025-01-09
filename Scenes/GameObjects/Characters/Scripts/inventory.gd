extends Node2D
class_name Inventory

var items: Array = []
var cur_weight: int = 0
var weight_cap: int = 50

func get_item_with_trait(property: String) -> int:
	var item_data = get_tree().get_first_node_in_group("gamedata").item_data
	for item in items:
		var items_data = item_data[item]
		if !items_data.has(property):
			continue
		return item
	return -1

func has(item: int) -> bool:
	return items.has(item)
	
func count(item: int) -> int:
	return items.count(item)

func add(item: int) -> bool:
	var item_data = get_tree().get_first_node_in_group("gamedata").item_data[item]
	if item_data["weight"] + cur_weight > weight_cap:
		return false
	items.append(item)
	cur_weight += item_data["weight"]
	return true
	
func remove(item: int) -> bool:
	if !items.has(item):
		return false
	var item_data = get_tree().get_first_node_in_group("gamedata").item_data[item]
	items.erase(item)
	cur_weight -= item_data["weight"]
	return true
