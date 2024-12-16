extends Task
class_name Build

var build_mat: int = -1
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"
@onready var character: CharacterBody2D = $"../../.."
@onready var gather: Gather = $"../Gather"
@onready var working: Working = $".."

func execute(args: Array) -> void:
	character.goal_pos = args[0]
	build_mat = args[1]
	if character.inventory.count(build_mat) <= 0:
		working.work_plan.push_front([gather, [build_mat]])
		gather.execute([build_mat])

func physics_update() -> void:
	if character.goal_pos == null:
		return
	var next_node = pathfinding.next_node(character.global_position)
	var vel = global_position.direction_to(next_node)
	character.velocity = vel * character.speed
	character.move_and_slide()
	if character.global_position.distance_to(character.goal_pos) < 35:
		character.build_layer.place_build(character.goal_pos, build_mat)
		character.inventory.erase(build_mat)
		exit()

func exit():
	character.goal_pos = null
	done_executing.emit()
