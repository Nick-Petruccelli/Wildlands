extends CharacterBody2D

@export var speed: int

@onready var mouse_select_state: MouseSelectState = %MouseSelectState

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var build_manager: Node2D = %BuildManager
var goal_pos = null
var cur_block = null

enum Tasks {Building, Minning, Gather, Ideling}
var cur_task = Tasks.Ideling
var cur_plan = []
var inventory = []

signal hovered
signal unhovered

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
	if cur_task != Tasks.Ideling:
		return
	var next_build = build_manager.get_next_build()
	if next_build.is_empty():
		return
	var build_loc = next_build[0]
	var build_mat = next_build[1]
	if build_mat in inventory:
		print(inventory)
		cur_plan.append([Tasks.Building, build_loc, build_mat])
	else:
		var mat_loc = build_manager.get_mat(build_mat)
		cur_plan.append([Tasks.Gather, build_mat])
		cur_plan.append([Tasks.Building, build_loc, build_mat])
		cur_task = Tasks.Gather
		goal_pos = mat_loc
	print(cur_plan)
	
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
	var curent_pos = global_position
	navigation_agent_2d.target_position = goal_pos
	var next_pos = navigation_agent_2d.get_next_path_position()
	var vel = curent_pos.direction_to(next_pos)
	navigation_agent_2d.set_velocity(vel)
	self.velocity = vel * speed
	move_and_slide()
	if navigation_agent_2d.distance_to_target() < 35:
		match cur_task:
			Tasks.Building:
				build_manager.place_build(goal_pos, cur_block)
				inventory.erase(cur_block)
				cur_block = null
				cur_task = Tasks.Ideling
				goal_pos = null
				cur_plan.pop_front()
			Tasks.Minning:
				build_manager.mine_build(goal_pos)
				cur_task = Tasks.Ideling
				goal_pos = null
			Tasks.Gather:
				inventory.append(cur_plan[0][1])
				cur_plan.pop_front()
				goal_pos = cur_plan[0][1]
				cur_task = cur_plan[0][0]
				cur_block = cur_plan[0][2]
	if navigation_agent_2d.is_navigation_finished():
		goal_pos = null
