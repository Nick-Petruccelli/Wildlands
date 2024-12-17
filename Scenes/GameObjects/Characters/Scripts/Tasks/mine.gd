extends Task
class_name Mine

@onready var character: CharacterBody2D = $"../../.."
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"

func execute(args: Array) -> void:
	character.goal_pos = args[0]

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
		var scene_manager = get_tree().get_first_node_in_group("scenemanager")
		scene_manager.get_child(3).mine(character.goal_pos)
		scene_manager.order_work("Haul", [character.goal_pos, 0])
		exit()

func exit() -> void:
	character.goal_pos = null
	done_executing.emit()
