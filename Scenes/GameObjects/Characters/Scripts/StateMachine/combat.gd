extends CharacterState

@onready var detection_zone: Area2D = $"../../DetectionZone"
@onready var character: Character = $"../.."

var target: Character = null

func enter() -> void:
	character.velocity = Vector2()
	character.equipment.weild_wepons()
	target = get_closest_hostile()
	character.combat_target = target

func exit() -> void:
	character.velocity = Vector2()
	
func update(_delta: float) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	target = get_closest_hostile()
	if target == null:
		transitioned.emit(self, "idel")
		return
	character.attack(target)
	
	
func get_closest_hostile() -> Character:
	var characters = detection_zone.get_overlapping_bodies()
	if characters.size() == 0:
		return null
	var closest = null
	var closest_dist = 999999999999999999.9
	for det_char in characters:
		if det_char.is_dead:
			continue
		if !character.is_hostile(det_char):
			continue
		if closest == null:
			closest = det_char
			closest_dist = det_char.global_position.distance_to(global_position)
			continue
		var dist_to_char = det_char.global_position.distance_to(global_position)
		if dist_to_char < closest_dist:
			continue
		closest = det_char
		closest_dist = dist_to_char
	return closest
