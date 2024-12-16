extends State
class_name MouseSelectState

var selected = null
var hovered_objs = []

func _ready() -> void:
	add_to_group("mouseselectstate")
func enter() -> void:
	selected = null
	hovering_ui = false

func exit() -> void:
	selected = null
	hovered_objs = []
	
func update(_delta: float) -> void:
	if Input.is_action_just_pressed('click') and !hovering_ui:
		if hovered_objs.is_empty():
			selected = null
			return
		selected = hovered_objs[0]
		
	
func physics_update(_delta: float) -> void:
	pass
	
func add_to_hovering(obj) -> void:
	hovered_objs.append(obj)	
func remove_from_hovering(obj) -> void:
	hovered_objs.erase(obj)
