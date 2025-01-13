extends CharacterState

@onready var detection_zone: Area2D = $"../../DetectionZone"
@onready var character: Character = $"../.."

func _physics_process(delta: float) -> void:
	var closest = get_closest_hostile()
	print(closest)
	if closest == null:
		return
	
	
func get_closest_hostile() -> Character:
	var characters = detection_zone.get_overlapping_bodies()
	if characters.size() == 0:
		return null
	var closest = null
	var closest_dist = 999999999999999999.9
	for det_char in characters:
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
