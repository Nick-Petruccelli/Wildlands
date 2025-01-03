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
@onready var working_state_nodes: Working = $StateMachine/Working
@onready var stats: CharacterStats = $Stats

signal work_done

var goal_pos = null
var cur_block = null
var cur_work = null
var cur_path = PackedVector2Array()
var cur_plan = []
var inventory = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exit)
	
func get_work_order(_work_queue: Array) -> void:
	if _work_queue.is_empty():
		return
	if cur_work != null:
		return
	var work_item = _work_queue.pop_front()
	var work_args = work_item[1]
	var task = work_item[0]
	for work in working_state_nodes.get_children():
		if work.name == task:
			cur_work = [work, work_args]
	
func _on_mouse_exit() -> void:
	mouse_select_state.remove_from_hovering(self)
	
func _on_mouse_entered() -> void:
	mouse_select_state.add_to_hovering(self)

func act_on_loc(loc: Vector2) -> void:
	goal_pos = loc
	%GameControler.unselect()

func move_with_vel() -> void:
	velocity  = velocity * speed * speed_mod
	move_and_slide()
