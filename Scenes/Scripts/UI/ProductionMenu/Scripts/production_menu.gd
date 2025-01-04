extends Panel


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		close_ui()
		
func close_ui() -> void:
	visible = false

func open_ui() -> void:
	visible = true
