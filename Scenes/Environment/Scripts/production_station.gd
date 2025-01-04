extends StaticBody2D
class_name ProductionStation

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var type_id: int = -1
var type_name: String
var producables: Dictionary

func load_data(id: int) -> void:
	var data = get_tree().get_first_node_in_group("gamedata").environment_data[id]
	type_id = data["id"]
	type_name = data["name"]
	var tex = load(data["texture"])
	sprite_2d.texture = tex
	collision_shape_2d.shape.set("size", tex.get_size())
	#var item_data = get_tree().get_first_node_in_group("gamedata").item_data
	
	

func open_ui() -> void:
	pass
