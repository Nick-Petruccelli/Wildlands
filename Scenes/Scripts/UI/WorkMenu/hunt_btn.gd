extends Button

@onready var action_state_machine: Node2D = %ActionStateMachine

func _ready() -> void:
	connect("button_up", _on_click)
	
func _on_click() -> void:
	var scene_manager = get_tree().get_first_node_in_group("scenemanager")
	scene_manager.order_work("Hunt", [scene_manager.animals.get_child(0)])
