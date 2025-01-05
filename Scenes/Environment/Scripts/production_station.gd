extends StaticBody2D
class_name ProductionStation

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var type_id: int = -1
var type_name: String
var inventory: Array = []
	
func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		load_menu()

func load_data(id: int) -> void:
	var data = get_tree().get_first_node_in_group("gamedata").environment_data[id]
	type_id = data["id"]
	type_name = data["name"]
	var tex = load(data["texture"])
	sprite_2d.texture = tex
	collision_shape_2d.shape.set("size", tex.get_size())
	load_menu()

func load_menu() -> void:
	var item_data = get_tree().get_first_node_in_group("gamedata").item_data
	var producables_list = get_tree().get_first_node_in_group("producableslist")
	for child in producables_list.get_children():
		child.queue_free()
	for id in item_data:
		if !item_data[id].has("prod_station") or item_data[id]["prod_station"] != type_id:
			continue
		var btn = CraftItemBtn.new()
		btn.text = item_data[id]["name"]
		btn.data = item_data[id]
		btn.station = self
		producables_list.add_child(btn)
		btn.init()
		print("btn initialized")
	var prod_menu = get_tree().get_first_node_in_group("productionmenu")
	prod_menu.open_ui()
	
func remove_mats_from_inventory(item_mats: Dictionary) -> void:
	for mat_name in item_mats:
		var mat_id = int(item_mats[mat_name][0])
		var mat_count = int(item_mats[mat_name][1])
		for i in range(mat_count):
			inventory.erase(mat_id)
