extends Task
class_name Chop

@onready var character: CharacterBody2D = $"../../.."
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"

var target: Plant = null
func execute(args: Array) -> void:
	target = args[0]
	character.goal_pos = target.global_position
	
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
		target.cut_down()
		var scene_manager = get_tree().get_first_node_in_group('scenemanager')
		scene_manager.order_work("Haul", [character.goal_pos, target.item_id])
		exit()

func exit() -> void:
	character.goal_pos = null
	done_executing.emit()
