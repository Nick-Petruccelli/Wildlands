extends StaticBody2D
class_name ProductionStation

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var type_id: int = -1
var type_name: String

func load_data(id: int) -> void:
	var data = get_tree().get_first_node_in_group("gamedata").environment_data[id]
	type_id = data["id"]
	type_name = data["name"]
	var tex = load(data["texture"])
	sprite_2d.texture = tex
	collision_shape_2d.shape.set("size", tex.get_size())
	open_ui()

func open_ui() -> void:
	var item_data = get_tree().get_first_node_in_group("gamedata").item_data
	var producables_list = get_tree().get_first_node_in_group("producableslist")
	for child in producables_list.get_children():
		child.queue_free()
	for id in item_data:
		print(item_data[id])
		if !item_data[id].has("prod_station") or item_data[id]["prod_station"] != type_id:
			continue
		var btn = ConstructionListItem.new()
		btn.text = item_data[id]["name"]
		btn.data = item_data[id]
		producables_list.add_child(btn)
