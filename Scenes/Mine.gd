extends Button


@onready var game_controler: Node2D = %GameControler
@export var tile_id: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("button_up", _on_click)


func _on_click() -> void:
	game_controler.mine_build()
