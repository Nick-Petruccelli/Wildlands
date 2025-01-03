extends Task
class_name Mine

@onready var character: CharacterBody2D = $"../../.."
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"

var swing_cooldown = 1000
var last_swing = -swing_cooldown
func execute(args: Array) -> void:
	character.goal_pos = args[0]

func update() -> void:
	pass
	
func physics_update() -> void:
	if character.global_position.distance_to(character.goal_pos) < 18:
		if Time.get_ticks_msec() - last_swing < swing_cooldown:
			return
		var scene_manager = get_tree().get_first_node_in_group("scenemanager")
		var block_broke = scene_manager.stone_layer.mine(character.goal_pos, character.stats.stats)
		last_swing = Time.get_ticks_msec()
		if block_broke:
			scene_manager.order_work("Haul", [character.goal_pos, 0])
			exit()
			return
	if character.goal_pos == null:
		return
	var next_node = pathfinding.next_node(character.global_position)
	var vel = character.global_position.direction_to(next_node)
	character.velocity = vel
	character.move_with_vel()

func exit() -> void:
	character.goal_pos = null
	done_executing.emit()
