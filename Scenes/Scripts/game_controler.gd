extends Node2D

var hovered_objs = []
var selected_obj = null
var placing_build = false
@onready var tile_map_layer: TileMapLayer = %TileMapLayer
@onready var build_manager: Node2D = %BuildManager
var build_map = {0: Vector2i(1,1)}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if selected_obj != null:
		#print("Selected obj: ", selected_obj)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print("mouse pressed at: ", get_global_mouse_position())
		if not hovered_objs.is_empty() and selected_obj == null:
			selected_obj = hovered_objs[0]
		
		if hovered_objs.is_empty():
			print('hit hov.emp')
			if placing_build:
				build_manager.order_build(get_global_mouse_position(), selected_obj)
				selected_obj = null
				placing_build = false
			if selected_obj != null:
				print('hit hov.emp and sel not null')
				selected_obj.act_on_loc(get_global_mouse_position())

func place_object(tile_id: int) -> void:
	placing_build = true
	selected_obj = tile_id

func add_to_hovering(obj) -> void:
	hovered_objs.append(obj)
	
func remove_from_hovering(obj) -> void:
	hovered_objs.erase(obj)
	
func unselect() -> void:
	selected_obj = null
