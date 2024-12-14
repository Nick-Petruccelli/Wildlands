extends Task
class_name Gather

@onready var character: CharacterBody2D = $"../../.."
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"

var item_to_gather: int = -1

func execute(args: Array) -> void:
	character.goal_pos = args[1]
	item_to_gather = args[2]
	

func update() -> void:
	pass
	
func physics_update() -> void:
	if character.goal_pos == null:
		return
	var next_node = pathfinding.next_node(global_position)
	var vel = global_position.direction_to(next_node)
	character.velocity = vel * character.speed
	character.move_and_slide()
	if character.global_position.distance_to(character.goal_pos) < 35:
		#character.build_manager.remove_from_stockpile(character.goal_pos, item_to_gather)
		character.inventory.append(item_to_gather)
		exit()

func exit() -> void:
	character.goal_pos = null
	item_to_gather = -1
	done_executing.emit()
