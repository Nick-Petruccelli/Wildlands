extends Node2D
class_name WeponObject

@onready var sprite_2d: Sprite2D = $Sprite2D
var character: Character
var dist_from_character: int = 6

func link_character(char: Character) -> void:
	character = char

func _process(delta: float) -> void:
	if sprite_2d.texture == null:
		return
	if character.combat_target == null:
		lower_wepon()
		return
	if character.global_position.distance_to(character.combat_target.global_position) > 200:
		lower_wepon()
		return
	aim_at(character.combat_target.global_position)
	
func lower_wepon() -> void:
	var pos = Vector2i(dist_from_character, 2)
	if character.velocity.x < 0:
		pos = Vector2i(-dist_from_character, 2)
	var rot = deg_to_rad(15.0)
	var fin_trans = Transform2D(rot, pos)
	sprite_2d.transform = sprite_2d.transform.interpolate_with(fin_trans, .1)

func aim_at(target: Vector2) -> void:
	var pos = (target - character.global_position).normalized() * dist_from_character
	var rot = character.global_position.angle_to_point(target)
	sprite_2d.flip_v = rot < deg_to_rad(-90) or rot > deg_to_rad(90)
	var fin_trans = Transform2D(rot, pos)
	sprite_2d.transform = sprite_2d.transform.interpolate_with(fin_trans, .1)
