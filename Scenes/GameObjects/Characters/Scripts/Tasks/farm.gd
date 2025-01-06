extends Task
class_name Farm

var seed: int = -1
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"
@onready var character: CharacterBody2D = $"../../.."
@onready var gather: Gather = $"../Gather"
@onready var working: Working = $".."

func execute(args: Array) -> void:
	if character.inventory.count(2) < 1:
		working.work_plan.push_front([gather, [2]])
		gather.execute([2])

func physics_update() -> void:
	if character.inventory.count(2) < 1:
		return
	character.equipment.equip(2)
	if character.goal_pos == null:
		return
	var next_node = pathfinding.next_node(character.global_position)
	var vel = global_position.direction_to(next_node)
	character.velocity = vel
	character.move_with_vel()
	if character.global_position.distance_to(character.goal_pos) < 18:
		exit()

func exit():
	character.goal_pos = null
	done_executing.emit()
