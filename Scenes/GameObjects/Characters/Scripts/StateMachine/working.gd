extends CharacterState
class_name Working

@onready var character: CharacterBody2D = $"../.."
var task_dict: Dictionary = {}
var work_plan: Array = []
var in_task: bool = false
var job_done = false

func enter() -> void:
	character.velocity = Vector2()
	character.cur_plan = []
	character.cur_path = PackedVector2Array()
	job_done = false
	for task in get_children():
		task_dict[task.name.to_lower()] = task
		task.done_executing.connect(_on_done_executing)

func exit() -> void:
	character.velocity = Vector2()
	
func update(_delta: float) -> void:
	if job_done == true:
		character.cur_work = null
	if character.cur_work == null:
		transitioned.emit(self, 'idel')
		return
	if in_task:
		return
	if work_plan.is_empty():
		work_plan.push_front(character.cur_work)
	var task = work_plan[0]
	task[0].execute(task[1])
	in_task = true
	
	
func physics_update(_delta: float) -> void:
	if work_plan.is_empty():
		return
	var task = work_plan[0]
	task[0].physics_update()

func _on_done_executing() -> void:
	work_plan.pop_front()
	if work_plan.is_empty():
		job_done = true
	in_task = false
