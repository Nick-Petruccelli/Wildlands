extends Task
class_name Build

var build: int = -1
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"
@onready var character: Character = $"../../.."
@onready var gather: Gather = $"../Gather"
@onready var working: Working = $".."

func execute(args: Array) -> void:
	character.goal_pos = args[0]
	build = args[1]
	var environment_data = get_tree().get_first_node_in_group("gamedata").environment_data
	var build_mats = environment_data[build]["build_mats"]
	for mat_name in build_mats:
		var build_mat = build_mats[mat_name]
		var mat_id = int(build_mat[0])
		var mat_count = int(build_mat[1])
		if character.inventory.count(mat_id) < mat_count:
			working.work_plan.push_front([gather, [mat_id]])
			gather.execute([mat_id])

func physics_update() -> void:
	if character.goal_pos == null:
		return
	var next_node = pathfinding.next_node(character.global_position)
	var vel = global_position.direction_to(next_node)
	character.velocity = vel
	character.move_with_vel()
	if character.global_position.distance_to(character.goal_pos) < 18:
		character.scene_manager.build(character.goal_pos, build)
		remove_mats_from_inventory()
		exit()

func exit():
	character.goal_pos = null
	done_executing.emit()

func remove_mats_from_inventory() -> void:
	var environment_data = get_tree().get_first_node_in_group("gamedata").environment_data
	var build_mats = environment_data[build]["build_mats"]
	for mat_name in build_mats:
		var build_mat = build_mats[mat_name]
		var mat_id = int(build_mat[0])
		var mat_count = int(build_mat[1])
		for i in range(mat_count):
			character.inventory.remove(mat_id)
