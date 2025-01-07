extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var deer = preload("res://Scenes/GameObjects/Animals/animal.tscn").instantiate()
	deer.animal_id = 0
	deer.global_position = Vector2(500, 100)
	add_child(deer)
	deer.init()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
