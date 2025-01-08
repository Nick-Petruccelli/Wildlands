extends Task
class_name Haul

@onready var character: CharacterBody2D = $"../../.."
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"

var has_item: bool = false
var item_id: int = -1
var storage_loc: Vector2i = Vector2i(-1,-1)
var start_inventory = null

func execute(args: Array) -> void:
	character.goal_pos = args[0]
	item_id = args[1]
	if args.size() == 3:
		start_inventory = args[2]
	var stock_piles = character.scene_manager.zone_layer.get_stockpiles()
	if stock_piles.is_empty():
		exit()
	var closest = null
	var min_dist = 999999999999999.9
	for pile in stock_piles:
		for row in pile:
			for tile in row:
				if tile[1] != -1:
					continue
				var dist = character.goal_pos.distance_to(Cords.get_global_from_map(tile[0]))
				if dist < min_dist:
					min_dist = dist
					closest = tile
	if closest == null:
		exit()
		return
	storage_loc = closest[0]
	closest[1] = -2
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
	if character.global_position.distance_to(character.goal_pos) < 21:
		var scene_manager = get_tree().get_first_node_in_group("scenemanager")
		if has_item:
			scene_manager.zone_layer.put_in_stockpile(storage_loc, item_id)
			character.inventory.erase(item_id)
			exit()
			return
		if start_inventory == null:
			scene_manager.ground_items.remove(Cords.get_map_from_global(character.goal_pos))
		else:
			start_inventory.inventory.erase(item_id)
		character.inventory.append(item_id)
		character.goal_pos = Cords.get_global_from_map(storage_loc)
		has_item = true

func exit() -> void:
	character.goal_pos = null
	item_id = -1
	has_item = false
	storage_loc = Vector2i(-1,-1)
	start_inventory = null
	done_executing.emit()
