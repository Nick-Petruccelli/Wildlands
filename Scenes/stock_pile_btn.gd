extends Button

@onready var scene_manager: Node2D = %SceneManager
func _ready() -> void:
	connect("button_up", _on_click)

func _on_click() -> void:
	scene_manager.add_stockpile()
