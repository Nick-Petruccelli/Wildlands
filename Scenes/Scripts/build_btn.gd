extends Button

@onready var game_controler: Node2D = %GameControler
@onready var build_manager: Node2D = %BuildManager
@export var tile_id: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("button_up", _on_click)


func _on_click() -> void:
	game_controler.set_mouse_action(func(pos: Vector2): build_manager.order_build(pos, tile_id))
