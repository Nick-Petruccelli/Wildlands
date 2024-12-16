extends Task
class_name Gather

@onready var character: CharacterBody2D = $"../../.."
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"

var item_to_gather: int = -1

func execute(args: Array) -> void:
	item_to_gather = args[0]
	var zone_layer = character.scene_manager.get_child(1)
	var mat_loc = zone_layer.get_mat(item_to_gather)
	character.goal_pos = mat_loc
	

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
