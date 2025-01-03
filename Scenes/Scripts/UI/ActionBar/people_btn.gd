extends Button

@onready var people_menu: Panel = %PeopleMenu
@onready var character_select: VBoxContainer = $"../../../../PeopleMenu/MarginContainer/ConstructionListContainer/HBoxContainer/CharacterSelect"

func _ready() -> void:
	connect("button_up", _on_click)

func _on_click() -> void:
	var action_bar: Panel = $"../../.."
	character_select.load_characters()
	action_bar.show_panel(people_menu)
