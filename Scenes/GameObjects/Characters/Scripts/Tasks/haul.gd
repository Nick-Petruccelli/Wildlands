extends Task
class_name Haul

@onready var character: Colonist = $"../../.."
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"

var has_item: bool = false
var item_id: int = -1
var storage_loc: Vector2i = Vector2i(-1,-1)
var start_inventory = null

func execute(args: Array) -> void:
	character.goal_pos = Cords.get_global_from_map(args[0])
	item_id = args[1]
	var item_weight = get_tree().get_first_node_in_group("gamedata").item_data[item_id]["weight"]
	if character.inventory.cur_weight + item_weight > character.inventory.weight_cap:
		var scene_manager = get_tree().get_first_node_in_group("scenemanager")
		scene_manager.order_work("Haul", args)
	if args.size() == 3:
		start_inventory = args[2]
	var ground_items = character.scene_manager.ground_items
	storage_loc = ground_items.get_free_stockpile_space(item_id)
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
	if character.global_position.distance_to(character.goal_pos) < 25:
		var scene_manager = get_tree().get_first_node_in_group("scenemanager")
		if has_item:
			while character.inventory.has(item_id):
				scene_manager.ground_items.add_to_stockpile(storage_loc, item_id)
				character.inventory.remove(item_id)
			exit()
			return
		var inv_full = false
		if start_inventory == null:
			var done = scene_manager.ground_items.remove(Cords.get_map_from_global(character.goal_pos))
			inv_full = !character.inventory.add(item_id)
			while !done and !inv_full:
				done = scene_manager.ground_items.remove(Cords.get_map_from_global(character.goal_pos))
				inv_full = !character.inventory.add(item_id)
			if inv_full and !done:
				scene_manager.ground_items.add(Cords.get_map_from_global(character.goal_pos), item_id)
				scene_manager.order_work("Haul", [Cords.get_map_from_global(character.goal_pos), item_id])
		else:
			start_inventory.inventory.erase(item_id)
			character.inventory.add(item_id)
		var task = get_nearby_haul_task()
		if task != [] and !inv_full:
			print("hit add nearby task")
			var loc = task[1][0]
			var item_id = task[1][1]
			character.working_state_nodes.work_plan.push_back([self, [loc, item_id]])
			exit()
			return
		character.goal_pos = Cords.get_global_from_map(storage_loc)
		has_item = true
		var ground_items = character.scene_manager.ground_items
		ground_items.reserve_stockpile_space(storage_loc, item_id)

func exit() -> void:
	character.goal_pos = null
	item_id = -1
	has_item = false
	storage_loc = Vector2i(-1,-1)
	start_inventory = null
	done_executing.emit()

func get_nearby_haul_task() -> Array:
	var work_queue = get_tree().get_first_node_in_group("scenemanager").work_queue
	for i in range(work_queue.size()):
		var task = work_queue[i]
		if task[0] != "Haul":
			continue
		if Cords.get_global_from_map(task[1][0]).distance_to(global_position) > 500:
			continue
		var out = work_queue.pop_at(i)
		return out
	return []
