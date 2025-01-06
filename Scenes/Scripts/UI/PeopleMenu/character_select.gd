extends VBoxContainer

func load_characters() -> void:
	var characters = get_tree().get_first_node_in_group("scenemanager").characters.get_children()
	var first: bool = true
	for btn in self.get_children():
		btn.queue_free()
	for character in characters:
		var btn = CharacterButton.new()
		btn.text = character.name
		btn.character = character
		btn.display = $"../CharacterDisplay"
		self.add_child(btn)
		if first:
			btn._on_click()
			first = false
	
