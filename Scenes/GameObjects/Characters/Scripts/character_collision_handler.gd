extends Area2D

@onready var character: Character = $".."

func _ready() -> void:
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)

func _on_area_entered(_area) -> void:
	character.speed_mod *= .80

func _on_area_exited(_area) -> void:
	character.speed_mod *= 1.25
