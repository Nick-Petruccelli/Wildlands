extends Node
class_name Crop

@onready var sprite_2d: Sprite2D = $Sprite2D

var map_pos: Vector2i
var crop_id: int
var time_planted: int

signal fully_grown

func init() -> void:
	var crop_data = get_tree().get_first_node_in_group("gamedata").item_data[crop_id]
	var tex = load(crop_data["farm_stats"]["growing_texture"])
	sprite_2d.texture = tex

func harvest() -> void:
	var crop_data = get_tree().get_first_node_in_group("gamedata").item_data[crop_id]
	if Time.get_ticks_msec() - time_planted < crop_data["farm_stats"]["grow_time"]:
		return
	var scene_manager = get_tree().get_first_node_in_group("scenemanager")
	scene_manager.add_ground_item(map_pos, crop_id)
	queue_free()
