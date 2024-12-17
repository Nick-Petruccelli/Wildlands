extends Task
class_name Haul

@onready var character: CharacterBody2D = $"../../.."
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"

var has_item: bool = false
var item_id: int = -1
var storage_loc: Vector2i = Vector2i(-1,-1)

func execute(args: Array) -> void:
	character.goal_pos = args[0]
	item_id = args[1]
	var stock_piles = character.scene_manager.zone_layer.get_stockpiles()
	var closest = null
	var min_dist = 999999999999999.9
	for pile in stock_piles:
		for row in pile:
			for tile in row:
				if tile[1] != -1:
					continue
				var dist = character.global_position.distance_to(Cords.get_global_from_map(tile[0]))
				if dist < min_dist:
					min_dist = dist
					closest = tile[0]
	if closest == null:
		exit()
	storage_loc = closest
	has_item = false

func update() -> void:
	pass
	
func physics_update() -> void:
	if character.goal_pos == null:
		return
	var next_node = pathfinding.next_node(character.global_position)
	var vel = character.global_position.direction_to(next_node)
	character.velocity = vel
	character.move_with_vel()
	if character.global_position.distance_to(character.goal_pos) < 18:
		var scene_manager = get_tree().get_first_node_in_group("scenemanager")
		if has_item:
			scene_manager.zone_layer.put_in_stockpile(storage_loc, item_id)
			character.inventory.erase(item_id)
			exit()
			return
		scene_manager.remove_ground_item(Cords.get_map_from_global(character.goal_pos), item_id)
		character.inventory.append(item_id)
		character.goal_pos = Cords.get_global_from_map(storage_loc)
		has_item = true

func exit() -> void:
	character.goal_pos = null
	item_id = -1
	has_item = false
	storage_loc = Vector2i(-1,-1)
	done_executing.emit()
