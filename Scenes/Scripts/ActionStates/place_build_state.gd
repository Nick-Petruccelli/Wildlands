extends State
class_name PlaceBuildState

@onready var build_layer: TileMapLayer = $"../../SceneManager/BuildLayer"
@onready var scene_manager: Node2D = %SceneManager
var cur_material = null
var mouse_down = null
var mouse_up = null

func enter(args: Array) -> void:
	cur_material = args[0]
	hovering_ui = true
	
func exit() -> void:
	cur_material = null
	
func update(_delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		transitioned.emit(self, 'mouseselectstate')
	if Input.is_action_just_pressed('click'):
		mouse_down = get_global_mouse_position()
	if Input.is_action_just_released('click') and !hovering_ui:
		if cur_material == null or mouse_down == null:
			return
		#build_layer.order_build(mouse_down, get_global_mouse_position(), cur_material)
		var build_tiles =  get_build_tiles(mouse_down, get_global_mouse_position())	
		for tile in build_tiles:
			scene_manager.order_work("Build", [tile, cur_material])
			
func get_build_tiles(down_pos: Vector2i, up_pos: Vector2i):
	var down_pos_map = Cords.get_map_from_global(down_pos)
	var up_pos_map = Cords.get_map_from_global(up_pos)
	var top_left = Vector2i(mini(down_pos_map.x, up_pos_map.x), mini(down_pos_map.y, up_pos_map.y))
	var bot_right = Vector2i(maxi(down_pos_map.x, up_pos_map.x), maxi(down_pos_map.y, up_pos_map.y))
	var out = []
	for y in range(top_left.y, bot_right.y+1):
		for x in range(top_left.x, bot_right.x+1):
			if build_layer.placed_build[x][y] != -1:
				continue
			out.push_back(Cords.get_global_from_map(Vector2i(x,y)))
	return out
func physics_update(_delta: float) -> void:
	pass
