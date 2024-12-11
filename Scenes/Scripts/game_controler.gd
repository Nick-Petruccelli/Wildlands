extends Node2D

var hovered_objs = []
var selected_obj = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if selected_obj != null:
		#print("Selected obj: ", selected_obj)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print("mouse pressed at: ", event.position)
		if not hovered_objs.is_empty() and selected_obj == null:
			selected_obj = hovered_objs[0]
		
		if hovered_objs.is_empty():
			print('hit hov.emp')
			if selected_obj != null:
				print('hit hov.emp and sel not null')
				selected_obj.act_on_loc(get_global_mouse_position())

func add_to_hovering(obj) -> void:
	hovered_objs.append(obj)
	
func remove_from_hovering(obj) -> void:
	hovered_objs.erase(obj)
	
func unselect() -> void:
	selected_obj = null
