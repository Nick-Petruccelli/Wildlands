extends Node
class_name Equipment

@onready var character: Character = $".."
var _equipment: Dictionary = {
	'head': -1,
	'body': -1,
	'legs': -1,
	'main_hand': -1,
	'off_hand': -1,
}

func equip(item_id: int) -> bool:
	var item_data = get_tree().get_first_node_in_group("gamedata").item_data[item_id]
	if !item_data["equipable"]:
		print(item_data["name"], " is not an equipable item.")
		return false
	if character.inventory.count(item_id) < 1:
		print(item_data["name"], " is not in inventory.")
		return false
	var equip_stats = item_data["equip_stats"]
	if !is_slot_empty(equip_stats["slot"]):
		unequip_item(equip_stats["slot"])
	equip_item(item_id, equip_stats)
	return true

func is_slot_empty(slot: String) -> bool:
	if slot == "two_handed":
		return is_slot_empty("main_hand") and is_slot_empty("off_hand")
	return _equipment[slot] == -1

func equip_item(item_id: int, equip_stats: Dictionary) -> void:
	var slot = equip_stats["slot"]
	if slot == "two_handed":
		character.inventory.erase(item_id)
		_equipment["main_hand"] = item_id
		_equipment["off_hand"] = -2
	else:
		character.inventory.erase(item_id)
		_equipment[slot] = item_id
	var character_skills = character.stats.skills
	for stat in equip_stats:
		if !character_skills.has(stat):
			continue
		character_skills[stat] += equip_stats[stat]

func unequip_item(equip_stats: Dictionary) -> void:
	var slot = equip_stats["slot"]
	if slot == "two_handed":
		character.inventory.append(_equipment["main_hand"])
		_equipment["main_hand"] = -1
		_equipment["off_hand"] = -1
	else:
		character.inventory.append(_equipment[slot])
		_equipment[slot] = -1
	var character_skills = character.stats.skills
	for stat in equip_stats:
		if !character_skills.has(stat):
			continue
		character_skills[stat] -= equip_stats[stat]

func equip_best_gear(stat: String) -> void:
	var stockpiles = get_tree().get_first_node_in_group("scenemanager").zone_layer.active_stockpiles
	var best_gear = _equipment.duplicate()
	var item_data = get_tree().get_first_node_in_group("gamedata").item_data
	for pile in stockpiles:
		for row in pile:
			for e in row:
				var item_id = e[1]
				var item = item_data[item_id]
				if !item["equipable"]:
					continue
				print("found hoe")
				var gather: Gather = $"../StateMachine/Working/Gather"
				character.working_state_nodes.work_plan.push_front([gather, [item["id"]]])
				gather.execute([item["id"]])
				return
