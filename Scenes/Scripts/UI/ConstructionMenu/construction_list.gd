extends VBoxContainer

var cur_state = "structures"

func _ready() -> void:
	load_structures()

func _process(delta: float) -> void:
	pass
func load_structures() -> void:
	for child in get_children():
		child.queue_free()
	cur_state = "structures"
	var game_data = %GameData
	var enviroment_data = game_data.environment_data
	for obj in enviroment_data:
		if enviroment_data[obj]["type"] != "Structure" or !enviroment_data[obj]["constructable"]:
			continue
		add_structure_to_list(enviroment_data[obj])
		
func load_storage() -> void:
	for child in get_children():
		child.queue_free()
	cur_state = "storage"
	add_storage_to_list()

func load_list(obj_type: String) -> void:
	for child in get_children():
		child.queue_free()
	cur_state = obj_type
	var game_data = %GameData
	var enviroment_data = game_data.environment_data
	for obj in enviroment_data:
		if enviroment_data[obj]["type"].to_lower() != obj_type or !enviroment_data[obj]["constructable"]:
			continue
		add_to_list(enviroment_data[obj])

func add_to_list(data: Dictionary) -> void:
	var btn = ConstructionListItem.new()
	btn.text = data["name"]
	btn.data = data
	self.add_child(btn)

func add_storage_to_list() -> void:
	var btn = Button.new()
	btn.text = "Stockpile Area"
	btn.pressed.connect(_on_item_pressed)
	self.add_child(btn)
	
func add_structure_to_list(data: Dictionary) -> void:
	var btn = ConstructionListItem.new()
	btn.text = data["name"]
	btn.data = data
	self.add_child(btn)
	
func _on_item_pressed() -> void:
	var asm_cur_state = get_tree().get_first_node_in_group("actionstatemachine").cur_state
	print(asm_cur_state)
	asm_cur_state.transitioned.emit(asm_cur_state, 'zoneplacingstate', [0])
