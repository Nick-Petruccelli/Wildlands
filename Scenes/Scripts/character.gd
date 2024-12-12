extends CharacterBody2D

@export var speed: int

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var build_manager: Node2D = %BuildManager
var goal_pos = null
var cur_block = null

enum Tasks {Building, Minning, Ideling}
var cur_task = Tasks.Ideling

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exit)
	build_manager.build_ordered.connect(_on_build_ordered)
	build_manager.minning_ordered.connect(_on_minning_ordered)
	
func _on_minning_ordered() -> void:
	var next_minning = build_manager.get_next_minning()
	if next_minning == null:
		return
	cur_task = Tasks.Minning
	goal_pos = next_minning
	
func _on_build_ordered() -> void:
	var next_build = build_manager.get_next_build()
	if next_build.is_empty():
		return
	cur_task = Tasks.Building
	goal_pos = next_build[0]
	cur_block = next_build[1]
	
	
func _on_mouse_exit() -> void:
	%GameControler.remove_from_hovering(self)
	
func _on_mouse_entered() -> void:
	%GameControler.add_to_hovering(self)

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
	#print(vel)
	self.velocity = vel * speed
	move_and_slide()
	if navigation_agent_2d.distance_to_target() < 35:
		match cur_task:
			Tasks.Building:
				build_manager.place_build(goal_pos, cur_block)
				cur_block = null
				cur_task = Tasks.Ideling
			Tasks.Minning:
				build_manager.mine_build(goal_pos)
				cur_task = Tasks.Ideling
		goal_pos = null
	if navigation_agent_2d.is_navigation_finished():
		goal_pos = null
