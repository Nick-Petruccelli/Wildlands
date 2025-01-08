extends Node2D

var id: int
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var count_label: Label = $CountLabel
var weight: int = 0
var item_name: String = ""
var count: int = 0

func load_item(item_id) -> void:
	var game_data: Node2D = get_tree().get_first_node_in_group("gamedata")
	var item_data = game_data.item_data[item_id]
	id = item_id
	var tex = load(item_data["texture"])
	sprite_2d.texture = tex
	weight = item_data["weight"]
	item_name = item_data["name"]

func add_count(n: int) -> void:
	count += n
	count_label.text = str(count)
	
func remove_count(n: int) -> void:
	count -= n
	count_label.text = str(count)
