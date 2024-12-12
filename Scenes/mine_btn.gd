extends Button


@onready var game_controler: Node2D = %GameControler
@onready var build_manager: Node2D = %BuildManager
func _ready() -> void:
	connect("button_up", _on_click)
	
func _on_click() -> void:
	game_controler.set_mouse_action(build_manager.order_minning)
