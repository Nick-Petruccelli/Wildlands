extends Task
class_name Hunt

@onready var character: CharacterBody2D = $"../../.."
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"

var wepon_range: int = 128
var target: Animal = null
var feild_dress_start_time: int = -1

func execute(args: Array) -> void:
	get_ranged_wepon()
	target = args[0]

func update() -> void:
	pass
	
func physics_update() -> void:
	character.goal_pos = target.global_position
	if target.is_dead():
		if character.global_position.distance_to(character.goal_pos) < 18:
			var done = feild_dress(target)
			if done:
				exit()
				return
	else:
		if character.global_position.distance_to(character.goal_pos) < wepon_range:
			character.attack(target)
			return
	if character.goal_pos == null:
		return
	var next_node = pathfinding.next_node(character.global_position)
	var vel = character.global_position.direction_to(next_node)
	character.velocity = vel
	character.move_with_vel()

func exit() -> void:
	character.goal_pos = null
	done_executing.emit()

func get_ranged_wepon() -> void:
	if !character.equipment.is_main_hand_ranged():
		if character.equipment.equip(4):
			return
		print("getting bow")
		var gather: Gather = $"../Gather"
		character.working_state_nodes.work_plan.push_front([gather, [4]])
		gather.execute([4])

func feild_dress(target: Animal) -> bool:
	if feild_dress_start_time < 0:
		feild_dress_start_time = Time.get_ticks_msec()
	
	if Time.get_ticks_msec() - feild_dress_start_time < target.feild_dress_time:
		return false
	var scene_manager = get_tree().get_first_node_in_group("scenemanager")
	for drop in target.drops:
		var drop_id = target.drops[drop][0]
		var drop_cords = scene_manager.add_ground_item(Cords.get_map_from_global(target.global_position), drop_id)
		scene_manager.order_work("Haul", [Cords.get_global_from_map(drop_cords), drop_id])
	target.queue_free()
	return true
