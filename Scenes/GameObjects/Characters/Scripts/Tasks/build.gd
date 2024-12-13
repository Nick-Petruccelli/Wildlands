extends Task
class_name Build

var build_mat: int = -1
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"
@onready var character: CharacterBody2D = $"../../.."

func execute(args: Array) -> void:
	character.goal_pos = args[1]
	build_mat = args[2]

func update() -> void:
	if character.goal_pos == null:
		return
	print("goal: ", character.goal_pos)
	var next_node = pathfinding.next_node(global_position)
	print("next: ", next_node)
	var vel = global_position.direction_to(next_node)
	character.velocity = vel * character.speed
	character.move_and_slide()
	if character.global_position.distance_to(character.goal_pos) < 35:
		character.build_manager.place_build(character.goal_pos, build_mat)
		character.inventory.erase(build_mat)
		exit()

func exit():
	character.goal_pos = null
	build_mat = -1
	done_executing.emit()
