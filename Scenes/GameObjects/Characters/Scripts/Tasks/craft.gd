extends Task
class_name Craft

@onready var character: CharacterBody2D = $"../../.."
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"
@onready var working: Working = $".."
@onready var gather: Gather = $"../Gather"

var station: ProductionStation = null
var item: Dictionary
var craft_start_time: int = -1

func execute(args: Array) -> void:
	station = args[0]
	item = args[1]
	character.goal_pos = station.global_position
	var build_mats = item["craft_mats"]
	for mat_name in build_mats:
		var mat_id = int(build_mats[mat_name][0])
		var mat_count = int(build_mats[mat_name][1])
		if character.inventory.count(mat_id) < mat_count:
			working.work_plan.push_front([gather, [mat_id]])
			gather.execute([mat_id])

func update() -> void:
	pass

func physics_update() -> void:
	if character.goal_pos == null:
		return
	print(character.global_position.distance_to(character.goal_pos))
	if character.global_position.distance_to(character.goal_pos) < 21:
		if craft_start_time == -1:
			craft_start_time = Time.get_ticks_msec()
			station.add_mats(character, item["craft_mats"])
			print("started crafting")
		var craft_dur = item["craft_dur"]
		if Time.get_ticks_msec() - craft_start_time > craft_dur:
			station.remove_mats_from_inventory(item["craft_mats"])
			station.inventory.append(item["id"])
			print("crafted ", item["name"])
			var scene_manager = get_tree().get_first_node_in_group('scenemanager')
			scene_manager.order_work("Haul", [station.global_position, item["id"], station])
			exit()
		return
	var next_node = pathfinding.next_node(character.global_position)
	var vel = character.global_position.direction_to(next_node)
	character.velocity = vel
	character.move_with_vel()

func exit() -> void:
	character.goal_pos = null
	done_executing.emit()
