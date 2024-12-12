extends Button

@onready var build_manager: Node2D = %BuildManager
@onready var game_controler: Node2D = %GameControler
func _ready() -> void:
	connect("button_up", _on_click)

func _on_click() -> void:
	game_controler.set_mouse_action(build_manager.add_stockpile)
