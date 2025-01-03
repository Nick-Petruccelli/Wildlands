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
	var wall_data_path = 'res://GameData/Environment/Walls/'
	var data_dir = open_dir(wall_data_path)
	if data_dir == null:
		return
	var data_files = data_dir.get_files()
	for file_name in data_files:
		var file = FileAccess.open(wall_data_path+file_name, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		add_structure_to_list(data)
		
func load_storage() -> void:
	for child in get_children():
		child.queue_free()
	cur_state = "storage"
	add_storage_to_list()

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

func open_dir(path: String) -> DirAccess:
	var dir = DirAccess.open(path)
	if dir == null:
		print("ERROR: failed to open directory at: ", path)
	return dir
