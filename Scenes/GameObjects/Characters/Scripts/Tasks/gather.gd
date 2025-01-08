extends Task
class_name Gather

@onready var character: CharacterBody2D = $"../../.."
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"

var item_to_gather: int = -1

func execute(args: Array) -> void:
	item_to_gather = args[0]
	print("gathering item: ", item_to_gather)
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
	character.velocity = vel
	character.move_with_vel()
	if character.global_position.distance_to(character.goal_pos) < 18:
		var scene_manager = get_tree().get_first_node_in_group("scenemanager")
		var ret = scene_manager.zone_layer.remove_from_stockpile(Cords.get_map_from_global(character.goal_pos), item_to_gather)
		if ret == -1:
			var zone_layer = character.scene_manager.get_child(1)
			var mat_loc = zone_layer.get_mat(item_to_gather)
			if mat_loc == Vector2i(-1,-1):
				exit()
				return
			character.goal_pos = mat_loc
			return
		character.inventory.append(item_to_gather)
		exit()

func exit() -> void:
	character.goal_pos = null
	item_to_gather = -1
	done_executing.emit()
