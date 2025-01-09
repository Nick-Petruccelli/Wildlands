extends Button

@onready var items_menu: Panel = %ItemsMenu
@onready var item_list: VBoxContainer = $"../../../../ItemsMenu/MarginContainer/ItemList"


func _ready() -> void:
	connect("button_up", _on_click)

func _on_click() -> void:
	var action_bar: Panel = $"../../.."
	action_bar.show_panel(items_menu)
	item_list.load_items()
