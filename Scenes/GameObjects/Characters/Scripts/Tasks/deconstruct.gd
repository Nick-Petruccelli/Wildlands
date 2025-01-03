extends Task
class_name Deconsturct

@onready var character: CharacterBody2D = $"../../.."
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"

var time_to_decon = 2000
var time_since_decon_start = null

func execute(args: Array) -> void:
	character.goal_pos = args[0]

func update() -> void:
	pass
	
func physics_update() -> void:
	if character.goal_pos == null:
		return
	if character.global_position.distance_to(character.goal_pos) < 18:
		if time_since_decon_start == null:
			time_since_decon_start = Time.get_ticks_msec()
		if Time.get_ticks_msec() - time_since_decon_start < time_to_decon:
			return
		var scene_manager = get_tree().get_first_node_in_group("scenemanager")
		scene_manager.build_layer.deconstruct_build(character.goal_pos)
		exit()
		return
	var next_node = pathfinding.next_node(character.global_position)
	var vel = character.global_position.direction_to(next_node)
	character.velocity = vel
	character.move_with_vel()
	
func exit() -> void:
	character.goal_pos = null
	done_executing.emit()
