extends Node2D

@onready var scene_manager: Node2D = %SceneManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_manager.add_ground_item(Vector2i(4,5),0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
