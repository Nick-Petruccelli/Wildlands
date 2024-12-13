extends CharacterState
class_name Working

@onready var character: CharacterBody2D = $"../.."
var task_dict: Dictionary = {}
var work_plan: Array = []
var in_task: bool = false

func enter() -> void:
	character.velocity = Vector2()
	character.cur_plan = []
	character.cur_path = PackedVector2Array()
	for task in get_children():
		task_dict[task.name.to_lower()] = task
		task.done_executing.connect(_on_done_executing)

func exit() -> void:
	character.velocity = Vector2()
	
func update(delta: float) -> void:
	print(character.work_queue)
	if character.work_queue.is_empty():
		transitioned.emit(self, 'idel')
		print('done working')
		return
	if in_task:
		return
	work_plan = character.work_queue[0]
	if work_plan.is_empty():
		character.work_queue.pop_front()
		return
	var task = work_plan[0]
	task[0].execute(task)
	in_task = true
	
	
func physics_update(delta: float) -> void:
	if work_plan.is_empty():
		return
	var task = work_plan[0]
	task[0].physics_update()

func _on_done_executing() -> void:
	work_plan.pop_front()
	in_task = false
