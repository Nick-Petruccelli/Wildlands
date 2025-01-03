extends Button

@onready var work_menu: Panel = %WorkMenu

func _ready() -> void:
	connect("button_up", _on_click)

func _on_click() -> void:
	var action_bar: Panel = $"../../.."
	action_bar.show_panel(work_menu)
