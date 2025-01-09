extends Button

@onready var scene_manager: Node2D = %SceneManager

func _ready() -> void:
	connect("button_up", _on_click)

func _on_click() -> void:
	scene_manager.in_dev_mode = !scene_manager.in_dev_mode
	if scene_manager.in_dev_mode:
		print("entered dev mode")
	else:
		print("exited dev mode")
	var items_btn: Button = $"../ItemsBtn"
	items_btn.visible = !items_btn.visible
