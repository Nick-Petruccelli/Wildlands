extends CharacterState
class_name Idel

@onready var character: Character = $"../.."
@onready var detection_zone: Area2D = $"../../DetectionZone"
@onready var timer: Timer = $Timer

func enter() -> void:
	character.velocity = get_rand_vel()
	character.cur_plan = []
	character.cur_path = PackedVector2Array()
	timer.timeout.connect(_on_timeout)

func exit() -> void:
	character.velocity = Vector2()
	
func update(_delta: float) -> void:
	if character.stats.stats["hunger"] <= 70:
		eat()
	if detection_zone != null and detection_zone.has_overlapping_bodies():
		transitioned.emit(self, 'combat')
	if character.cur_work != null:
		transitioned.emit(self, 'working')
	
func physics_update(_delta: float) -> void:
	character.move_with_vel()

func _on_timeout() -> void:
	character.velocity = get_rand_vel()
	
func get_rand_vel() -> Vector2:
	var x = randf_range(-1/2, 1/2)
	var y = randf_range(-1/2, 1/2)
	return Vector2(x, y)

func eat() -> void:
	if character.inventory.get_item_with_trait("consumable") == -1:
		var ground_items = get_tree().get_first_node_in_group("scenemanager").ground_items
		var consumable = ground_items.get_item_with_trait("consumable")
		if consumable == null:
			return
		var gather = $"../Working/Gather"
		character.cur_work = [gather, [consumable.id]]
		return
	var consumeable = character.inventory.get_item_with_trait("consumable")
	var consume_effects = get_tree().get_first_node_in_group("gamedata").item_data[consumeable]["consume_effects"]
	character.inventory.remove(consumeable)
	for stat in consume_effects["instant"]:
		if stat in character.stats.stats:
			character.stats.stats[stat] += consume_effects["instant"][stat]
