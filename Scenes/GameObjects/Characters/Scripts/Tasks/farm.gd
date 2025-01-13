extends Task
class_name Farm

enum FarmTask {
	TILL,
	PLANT,
	HARVEST,
}

var crop_id: int = -1
var task: FarmTask

@onready var pathfinding: Pathfinding = $"../../../Pathfinding"
@onready var character: Character = $"../../.."
@onready var gather: Gather = $"../Gather"
@onready var working: Working = $".."

func execute(args: Array) -> void:
	var tile = args[0]
	crop_id = args[1]
	if is_correct_floor(tile):
		var farms = get_tree().get_first_node_in_group("scenemanager").farms
		if farms.tile_planted(tile):
			task = FarmTask.HARVEST
			character.goal_pos = Cords.get_global_from_map(tile)
			return
		task = FarmTask.PLANT
		character.goal_pos = Cords.get_global_from_map(tile)
		return
	#if character.inventory.count(2) < 1:
		#working.work_plan.push_front([gather, [2]])
		#gather.execute([2])
	character.goal_pos = Cords.get_global_from_map(tile)
	task = FarmTask.TILL

func physics_update() -> void:
	if character.goal_pos == null:
		return
	if character.global_position.distance_to(character.goal_pos) < 18:
		match task:
			FarmTask.TILL:
				till(Cords.get_map_from_global(character.goal_pos))
			FarmTask.PLANT:
				plant(Cords.get_map_from_global(character.goal_pos))
			FarmTask.HARVEST:
				harvest(Cords.get_map_from_global(character.goal_pos))
		exit()
		return
	var next_node = pathfinding.next_node(character.global_position)
	var vel = global_position.direction_to(next_node)
	character.velocity = vel
	character.move_with_vel()

func exit():
	character.goal_pos = null
	done_executing.emit()

func is_correct_floor(tile: Vector2i) -> bool:
	var floor_layer: TileMapLayer = get_tree().get_first_node_in_group("scenemanager").floor_layer
	var game_data = get_tree().get_first_node_in_group("gamedata")
	var item_data = game_data.item_data[crop_id]
	var grow_tile = int(item_data["farm_stats"]["grow_floor"])
	var grow_tile_data = game_data.environment_data[grow_tile]
	var terrain_set = grow_tile_data["terrain_set"]
	var terrain_id = grow_tile_data["terrain_id"]
	var tile_data = floor_layer.get_cell_tile_data(tile)
	return terrain_set == tile_data.terrain_set and terrain_id == tile_data.terrain

func till(tile: Vector2i) -> void:
	var floor_layer: TileMapLayer = get_tree().get_first_node_in_group("scenemanager").floor_layer
	var game_data = get_tree().get_first_node_in_group("gamedata")
	var item_data = game_data.item_data[crop_id]
	var grow_tile = int(item_data["farm_stats"]["grow_floor"])
	var grow_tile_data = game_data.environment_data[grow_tile]
	var terrain_set = grow_tile_data["terrain_set"]
	var terrain_id = grow_tile_data["terrain_id"]
	var tile_data = floor_layer.get_cell_tile_data(tile)
	floor_layer.set_floor_tile(tile, terrain_set, terrain_id)

func plant(tile: Vector2i) -> void:
	var farms = get_tree().get_first_node_in_group("scenemanager").farms
	farms.plant(tile, crop_id)

func harvest(tile: Vector2i) -> void:
	var farms = get_tree().get_first_node_in_group("scenemanager").farms
	farms.harvest(tile)
