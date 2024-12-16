extends CharacterBody2D

@export var speed: int
var speed_mod = 1

#@onready var mouse_select_state: MouseSelectState = %MouseSelectState
@onready var mouse_select_state: MouseSelectState = get_tree().get_first_node_in_group("mouseselectstate")
@onready var floor_layer: TileMapLayer = $"../../FloorLayer"
@onready var build_layer: TileMapLayer = $"../../BuildLayer"
@onready var state_machine: Node2D = $StateMachine
@onready var pathfinding: Pathfinding = $Pathfinding
@onready var scene_manager: Node2D = get_tree().get_first_node_in_group("scenemanager")
@onready var working_state_nodes: Working = $StateMachine/Working

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
	#build_layer.build_ordered.connect(_on_build_ordered)
	#build_layer.minning_ordered.connect(_on_minning_ordered)
	
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

func _on_minning_ordered() -> void:
	if state_machine.cur_state.name.to_lower() != 'idel':
		return
	var deconstruct_loc = build_layer.get_next_minning()
	if deconstruct_loc == null:
		return
	var work_plan = [[$StateMachine/Working/Deconstruct, deconstruct_loc]]
	cur_work = work_plan
	
func _on_build_ordered() -> void:
	if state_machine.cur_state.name.to_lower() != 'idel':
		return
	var next_build = build_layer.get_next_build()
	if next_build.is_empty():
		return
	var build_loc = next_build[0]
	var build_mat = next_build[1]
	var work_plan = []
	if build_mat in inventory:
		work_plan.append([$StateMachine/Working/Build, build_loc, build_mat])
	else:
		var mat_loc = build_layer.get_mat(build_mat)
		if mat_loc == Vector2i(-1,-1):
			mat_loc = scene_manager.get_item(build_mat)
			if mat_loc == Vector2i(-1,-1):
				return
		work_plan.append([$StateMachine/Working/Gather, mat_loc, build_mat])
		work_plan.append([$StateMachine/Working/Build, build_loc, build_mat])
	cur_work = work_plan
	
func _on_mouse_exit() -> void:
	mouse_select_state.remove_from_hovering(self)
	
func _on_mouse_entered() -> void:
	mouse_select_state.add_to_hovering(self)

func act_on_loc(loc: Vector2) -> void:
	goal_pos = loc
	%GameControler.unselect()

func move_with_vel() -> void:
	print(speed_mod)
	velocity  = velocity * speed * speed_mod
	move_and_slide()
