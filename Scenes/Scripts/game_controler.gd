extends Node2D


@onready var tile_map_layer: TileMapLayer = %TileMapLayer
@onready var build_manager: Node2D = %BuildManager

enum CursorMode {Minning, Building, Zoneing}

var build_map = {0: Vector2i(1,1)}
var hovered_objs = []
var selected_obj = null
var placing_build = false
var minning = false
var mouse_down_at = null
var cur_mouse_action = null
var cur_mouse_action_args = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_mouse_action(fun: Callable) -> void:
	cur_mouse_action = fun
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		mouse_down_at = get_global_mouse_position()
	if event is InputEventMouseButton and event.is_released():
		if not hovered_objs.is_empty() and selected_obj == null:
			selected_obj = hovered_objs[0]
		
		if hovered_objs.is_empty():
			if cur_mouse_action != null:
				cur_mouse_action.call(mouse_down_at, get_global_mouse_position())
				cur_mouse_action = null
		mouse_down_at = null

func place_object(tile_id: int) -> void:
	placing_build = true
	selected_obj = tile_id

func mine_build() -> void:
	minning = true
	placing_build = false
	selected_obj = null

func add_to_hovering(obj) -> void:
	hovered_objs.append(obj)
	
func remove_from_hovering(obj) -> void:
	hovered_objs.erase(obj)
	
func unselect() -> void:
	selected_obj = null
