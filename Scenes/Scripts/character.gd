extends CharacterBody2D

const speed = 10
var goal_pos = null
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exit)
	
func _on_mouse_exit() -> void:
	%GameControler.remove_from_hovering(self)
	
func _on_mouse_entered() -> void:
	print("hit")
	%GameControler.add_to_hovering(self)

func act_on_loc(loc: Vector2) -> void:
	goal_pos = loc
	%GameControler.unselect()
	print("Goal pos: ", goal_pos)

func _physics_process(delta: float) -> void:
	if goal_pos == null:
		return
	var curent_pos = global_position
	navigation_agent_2d.target_position = goal_pos
	var next_pos = navigation_agent_2d.get_next_path_position()
	print("cur: ", curent_pos)
	print('next: ', next_pos)
	var vel = curent_pos.direction_to(next_pos)
	navigation_agent_2d.set_velocity(vel)
	#print(vel)
	self.velocity = vel * speed
	move_and_slide()
