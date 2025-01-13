extends CharacterBody2D
class_name Character

@export var speed: int
var speed_mod = 1

#@onready var mouse_select_state: MouseSelectState = %MouseSelectState
@onready var mouse_select_state: MouseSelectState = get_tree().get_first_node_in_group("mouseselectstate")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: Node2D = $StateMachine
@onready var pathfinding: Pathfinding = $Pathfinding
@onready var scene_manager: Node2D = get_tree().get_first_node_in_group("scenemanager")
@onready var stats: CharacterStats = $Stats
@onready var equipment: Equipment = $Equipment
@onready var inventory: Inventory = $Inventory

enum ColonyRelationship {
	MEMBER,
	FREIND,
	NEUTRAL,
	HOSTILE,
}
var goal_pos = null
var cur_block = null
var cur_work = null
var cur_plan = []
var cur_path: PackedVector2Array
var combat_target = null
@export var colony_relationship: ColonyRelationship = ColonyRelationship.NEUTRAL
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exit)
	
func _on_mouse_exit() -> void:
	mouse_select_state.remove_from_hovering(self)
	
func _on_mouse_entered() -> void:
	mouse_select_state.add_to_hovering(self)

func move_with_vel() -> void:
	velocity  = velocity * speed * speed_mod
	move_and_slide()

func attack(target) -> void:
	equipment.main_hand_wepon.attack(target.global_position)
	

func get_final_damage(main_hand_damage: int, off_hand_damage: int) -> int:
	var main_hand_ranged = equipment.is_main_hand_ranged()
	print("predamage: ", main_hand_damage)
	var off_hand_ranged = equipment.is_off_hand_ranged()
	print("modifier: ", (stats.skills["ranged"] / 5.0))
	if main_hand_ranged:
		main_hand_damage = main_hand_damage * (stats.skills["ranged"] / 5.0)
	else:
		main_hand_damage = main_hand_damage * (stats.skills["melee"] / 5.0)
	if off_hand_ranged:
		off_hand_damage = off_hand_damage * (stats.skills["ranged"] / 5.0)
	else:
		off_hand_damage = off_hand_damage * (stats.skills["melee"] / 5.0)
	return main_hand_damage + off_hand_damage

func is_hostile(character: Character) -> bool:
	#TODO This function will eventualy use faction system to determine hostility between characters
	if colony_relationship == ColonyRelationship.MEMBER and character.colony_relationship == ColonyRelationship.HOSTILE:
		return true
	if colony_relationship == ColonyRelationship.HOSTILE and character.colony_relationship == ColonyRelationship.MEMBER:
		return true
	return false
