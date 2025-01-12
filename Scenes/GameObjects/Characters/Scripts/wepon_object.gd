extends Node2D
class_name WeponObject

@onready var sprite_2d: Sprite2D = $Sprite2D
var character: Character
var dist_from_character: int = 6
var wepon_data: Dictionary = {}
var last_attack: int = 0

func link_character(char: Character) -> void:
	character = char

func equip(wepon_id: int) -> void:
	wepon_data = get_tree().get_first_node_in_group("gamedata").item_data[wepon_id]
	var tex = load(wepon_data["texture"])
	sprite_2d.texture = tex

func unequip() -> void:
	sprite_2d.texture = null
	wepon_data = {}

func attack(target: Vector2i) -> void:
	if Time.get_ticks_msec() - last_attack < wepon_data["equip_stats"]["cooldown"]:
		return
	print("attack hit")
	last_attack = Time.get_ticks_msec()
	var projectiles = get_tree().get_first_node_in_group("scenemanager").projectiles
	var damage = wepon_data["equip_stats"]["damage"]
	var direction = global_position.direction_to(target)
	var projectile_id = wepon_data["equip_stats"]["projectile"]
	var accuracy = character.stats.skills["ranged"]
	var wepon_length = sprite_2d.texture.get_size().x
	var pos = global_position + wepon_length * direction
	projectiles.add(projectile_id, pos, direction,damage , accuracy)

func _process(delta: float) -> void:
	if sprite_2d.texture == null:
		return
	if character.combat_target == null:
		lower_wepon()
		return
	if character.global_position.distance_to(character.combat_target.global_position) > 300:
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
