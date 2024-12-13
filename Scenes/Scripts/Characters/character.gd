extends CharacterBody2D

@export var speed: int

@onready var mouse_select_state: MouseSelectState = %MouseSelectState
@onready var tile_map_layer: TileMapLayer = %TileMapLayer
@onready var state_machine: Node2D = $StateMachine
@onready var build_manager: Node2D = %BuildManager
@onready var pathfinding: Pathfinding = $Pathfinding

var goal_pos = null
var cur_block = null
var work_queue = []

enum Tasks {Building, Minning, Gather, Ideling}
var cur_task = Tasks.Ideling
var cur_plan = []
var inventory = []
var cur_path: PackedVector2Array = []
var cur_path_idx = 0
var timer_ticked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exit)
	build_manager.build_ordered.connect(_on_build_ordered)
	build_manager.minning_ordered.connect(_on_minning_ordered)
	
func _on_minning_ordered() -> void:
	if cur_task != Tasks.Ideling:
		return
	var next_minning = build_manager.get_next_minning()
	if next_minning == null:
		return
	cur_task = Tasks.Minning
	goal_pos = next_minning
	
func _on_build_ordered() -> void:
	if state_machine.cur_state.name.to_lower() != 'idel':
		print('hit')
		return
	var next_build = build_manager.get_next_build()
	if next_build.is_empty():
		return
	var build_loc = next_build[0]
	var build_mat = next_build[1]
	var work_plan = []
	if build_mat in inventory:
		work_plan.append([Tasks.Building, build_loc, build_mat])
	else:
		var mat_loc = build_manager.get_mat(build_mat)
		work_plan.append([$StateMachine/Working/Gather, mat_loc, build_mat])
		work_plan.append([$StateMachine/Working/Build, build_loc, build_mat])
	work_queue.append(work_plan)
	
func _on_mouse_exit() -> void:
	mouse_select_state.remove_from_hovering(self)
	
func _on_mouse_entered() -> void:
	mouse_select_state.add_to_hovering(self)

func act_on_loc(loc: Vector2) -> void:
	goal_pos = loc
	%GameControler.unselect()

func _physics_process(delta: float) -> void:
	if goal_pos == null:
		return
	var next_node = pathfinding.next_node(global_position)
	var vel = global_position.direction_to(next_node)
	self.velocity = vel * speed
	move_and_slide()
	if global_position.distance_to(goal_pos) < 35:
		match cur_task:
			Tasks.Minning:
				build_manager.mine_build(goal_pos)
				cur_task = Tasks.Ideling
				goal_pos = null
