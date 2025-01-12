extends Character
class_name Colonist

@onready var working_state_nodes: Working = $StateMachine/Working

signal work_done

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
			print("hit: ", work.name)
