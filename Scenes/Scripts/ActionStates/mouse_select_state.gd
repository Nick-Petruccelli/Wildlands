extends State
class_name MouseSelectState

var selected = null
var hovered_objs = []
func enter() -> void:
	selected = null
	hovering_ui = false

func exit() -> void:
	selected = null
	hovered_objs = []
	
func update(delta: float) -> void:
	if Input.is_action_just_pressed('click') and !hovering_ui:
		if hovered_objs.is_empty():
			selected = null
			return
		selected = hovered_objs[0]
		
	
func physics_update(delta: float) -> void:
	pass

func add_to_hovering(obj) -> void:
	hovered_objs.append(obj)	
func remove_from_hovering(obj) -> void:
	hovered_objs.erase(obj)
	hovered_objs.erase(obj)
