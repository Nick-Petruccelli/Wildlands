extends Task

@onready var character: CharacterBody2D = $"../../.."
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"

func execute(args: Array) -> void:
	character.goal_pos = args[1]

func update() -> void:
	pass
	
func physics_update() -> void:
	if character.goal_pos == null:
		return
	print_debug("goal: ", character.goal_pos)
	var next_node = pathfinding.next_node(character.global_position)
	print_debug("next: ", next_node)
	var vel = character.global_position.direction_to(next_node)
	character.velocity = vel * character.speed
	character.move_and_slide()
	if character.global_position.distance_to(character.goal_pos) < 35:
		character.build_layer.deconstruct_build(character.goal_pos)
		exit()

func exit() -> void:
	character.goal_pos = null
	done_executing.emit()
