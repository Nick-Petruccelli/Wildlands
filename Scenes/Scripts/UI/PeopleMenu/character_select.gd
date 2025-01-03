extends VBoxContainer

func load_characters() -> void:
	var characters = get_tree().get_first_node_in_group("scenemanager").characters.get_children()
	for character in characters:
		var btn = CharacterButton.new()
		btn.text = character.name
		btn.character = character
		btn.display = $"../CharacterDisplay"
		self.add_child(btn)
