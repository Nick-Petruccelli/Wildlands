extends Node2D
class_name WeponObject

@onready var wepon_sprite: Sprite2D = $WeponSprite
@onready var attack_time_display: Sprite2D = $AttackTimeDisplay
var character: Character
var dist_from_character: int = 6
var wepon_data: Dictionary = {}
var attack_start: int = 0
var attacking: bool = false

func link_character(char: Character) -> void:
	character = char

func equip(wepon_id: int) -> void:
	wepon_data = get_tree().get_first_node_in_group("gamedata").item_data[wepon_id]
	var tex = load(wepon_data["texture"])
	wepon_sprite.texture = tex

func unequip() -> void:
	wepon_sprite.texture = null
	attack_time_display.texture = null
	wepon_data = {}

func is_in_attack_range(target: Vector2) -> bool:
	if wepon_data == {}:
		return false
	return global_position.distance_to(target) <= wepon_data["equip_stats"]["range"]

func attack(target: Vector2i) -> void:
	attack_time_display.texture = null
	if !attacking:
		attack_start = Time.get_ticks_msec()
		attacking = true
	var time_since_attack_start = Time.get_ticks_msec() - attack_start
	if time_since_attack_start < wepon_data["equip_stats"]["attack_time"]:
		var proportion_remain = float(time_since_attack_start) / wepon_data["equip_stats"]["attack_time"]
		display_attack_time(proportion_remain)
		return
	var projectiles = get_tree().get_first_node_in_group("scenemanager").projectiles
	var damage = wepon_data["equip_stats"]["damage"]
	var direction = global_position.direction_to(target)
	var projectile_id = wepon_data["equip_stats"]["projectile"]
	var accuracy = character.stats.skills["ranged"]
	var wepon_length = wepon_sprite.texture.get_size().x
	var pos = global_position + wepon_length * direction
	projectiles.add(projectile_id, pos, direction,damage , accuracy)
	attack_time_display.texture = null
	attacking = false

func _process(delta: float) -> void:
	if wepon_sprite.texture == null:
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
	wepon_sprite.transform = wepon_sprite.transform.interpolate_with(fin_trans, .1)

func aim_at(target: Vector2) -> void:
	var wep_pos = (target - character.global_position).normalized() * dist_from_character
	var dis_pos = (target - character.global_position).normalized() * (dist_from_character + 5)
	var rot = character.global_position.angle_to_point(target)
	wepon_sprite.flip_v = rot < deg_to_rad(-90) or rot > deg_to_rad(90)
	var wep_fin_trans = Transform2D(rot, wep_pos)
	var dis_fin_trans = Transform2D(rot, dis_pos)
	wepon_sprite.transform = wepon_sprite.transform.interpolate_with(wep_fin_trans, .1)
	attack_time_display.transform = attack_time_display.transform.interpolate_with(dis_fin_trans, .1)

func display_attack_time(proportion_remain: float) -> void:
	var tex = null
	if proportion_remain < .10:
		tex = null
	elif proportion_remain < .33:
		tex = load("res://Assets/attack_time_full.png")
	elif proportion_remain < .66:
		tex = load("res://Assets/attack_time_two_third.png")
	else:
		tex = load("res://Assets/attack_time_one_third.png")
	attack_time_display.texture = tex
