extends CharacterState
class_name Idel

@onready var character: CharacterBody2D = $"../.."
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
	if !character.inventory.has(9):
		var ground_items = get_tree().get_first_node_in_group("scenemanager").ground_items
		if ground_items.get_item_loc(9) == Vector2i(-1,-1):
			return
		print("hit gathering food")
		var gather = $"../Working/Gather"
		character.cur_work = [gather, [9]]
		return
	print("hit eating food")
	var consume_effects = get_tree().get_first_node_in_group("gamedata").item_data[9]["consume_effects"]
	for stat in consume_effects["instant"]:
		if stat in character.stats.stats:
			character.stats.stats[stat] += consume_effects["instant"][stat]
