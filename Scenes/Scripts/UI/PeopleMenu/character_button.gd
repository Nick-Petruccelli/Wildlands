extends Button
class_name CharacterButton

var character = null
var display = null

func _ready() -> void:
	connect("button_up", _on_click)

func _on_click() -> void:
	display.show_character(character)
