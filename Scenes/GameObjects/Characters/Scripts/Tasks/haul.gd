extends Task
class_name Haul

@onready var character: CharacterBody2D = $"../../.."
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"

var has_item: bool = false
var item_id: int = -1
var storage_loc: Vector2i = Vector2i(-1,-1)
var start_inventory = null

func execute(args: Array) -> void:
	character.goal_pos = Cords.get_global_from_map(args[0])
	item_id = args[1]
	if args.size() == 3:
		start_inventory = args[2]
	var ground_items = character.scene_manager.ground_items
	storage_loc = ground_items.get_item_loc(item_id)
	if storage_loc == Vector2i(-1,-1):
		storage_loc = ground_items.get_free_stockpile_space()
	if storage_loc == Vector2i(-1,-1):
		exit()
		return
	ground_items.reserve_stockpile_space(storage_loc, item_id)
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
			while character.inventory.has(item_id):
				scene_manager.ground_items.add_to_stockpile(storage_loc, item_id)
				character.inventory.erase(item_id)
			exit()
			return
		if start_inventory == null:
			var done = scene_manager.ground_items.remove(Cords.get_map_from_global(character.goal_pos))
			character.inventory.append(item_id)
			while !done:
				done = scene_manager.ground_items.remove(Cords.get_map_from_global(character.goal_pos))
				character.inventory.append(item_id)
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
