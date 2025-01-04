extends Button

func _ready() -> void:
	connect("button_up", _on_click)

func _on_click() -> void:
	var construction_list_container: VBoxContainer = $"../.."
	construction_list_container.get_child(1).load_list("structure")
