extends Task
class_name Hunt

@onready var character: CharacterBody2D = $"../../.."
@onready var pathfinding: Pathfinding = $"../../../Pathfinding"

var wepon_range: int = 128
var target: Animal = null
func execute(args: Array) -> void:
	target = args[0]

func update() -> void:
	pass
	
func physics_update() -> void:
	character.goal_pos = target.global_position
	if character.global_position.distance_to(character.goal_pos) < wepon_range:
		character.attack(target)
		if target.is_dead():
			print("animal dead")
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
