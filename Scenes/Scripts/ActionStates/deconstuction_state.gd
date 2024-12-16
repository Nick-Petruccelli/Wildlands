extends State
class_name DeconstuctionState

@onready var build_layer: TileMapLayer = $"../../SceneManager/BuildLayer"
@onready var scene_manager: Node2D = %SceneManager
var down_pos = null

func enter() -> void:
	down_pos = null
	hovering_ui = true
	
func exit() -> void:
	down_pos = null
	
func update(_delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		transitioned.emit(self, 'mouseselectstate')
	if Input.is_action_just_pressed("click"):
		down_pos = get_global_mouse_position()
	if Input.is_action_just_released("click") and !hovering_ui:
		if down_pos == null:
			return
		#build_layer.order_deconstuction(down_pos, get_global_mouse_position())
		var deconstruct_tiles = get_deconstruct_tiles(down_pos, get_global_mouse_position())
		for tile in deconstruct_tiles:
			scene_manager.order_work("Deconstruct", [tile])

func physics_update(_delta: float) -> void:
	pass

func get_deconstruct_tiles(down_pos: Vector2i, up_pos: Vector2i) -> Array[Vector2i]:
	var down_pos_map = Cords.get_map_from_global(down_pos)
	var up_pos_map = Cords.get_map_from_global(up_pos)
	var top_left = Vector2i(mini(down_pos_map.x, up_pos_map.x), mini(down_pos_map.y, up_pos_map.y))
	var bot_right = Vector2i(maxi(down_pos_map.x, up_pos_map.x), maxi(down_pos_map.y, up_pos_map.y))
	var out = []
	for y in range(top_left.y, bot_right.y+1):
		for x in range(top_left.x, bot_right.x+1):
			if build_layer.placed_build[x][y] == -1:
				continue
			out.push_back(Cords.get_global_from_map(Vector2i(x,y)))
	return out
