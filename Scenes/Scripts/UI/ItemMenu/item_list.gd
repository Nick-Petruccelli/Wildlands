extends VBoxContainer

func _ready() -> void:
	load_items()

func _process(delta: float) -> void:
	pass
func load_items() -> void:
	for child in get_children():
		child.queue_free()
	var game_data = %GameData
	var item_data = game_data.item_data
	for item in item_data:
		add_item_to_list(item_data[item])
	
func add_item_to_list(data: Dictionary) -> void:
	var btn = ItemListBtn.new()
	btn.text = data["name"]
	btn.data = data
	self.add_child(btn)
	
func _on_item_pressed() -> void:
	var asm_cur_state = get_tree().get_first_node_in_group("actionstatemachine").cur_state
	asm_cur_state.transitioned.emit(asm_cur_state, 'zoneplacingstate', [0])
