extends CharacterState
class_name Idel

@onready var character: CharacterBody2D = $"../.."
@onready var timer: Timer = $Timer

func enter() -> void:
	character.velocity = get_rand_vel()
	character.cur_plan = []
	character.cur_path = PackedVector2Array()
	timer.timeout.connect(_on_timeout)

func exit() -> void:
	character.velocity = Vector2()
	
func update(_delta: float) -> void:
	if character.cur_work != null:
		transitioned.emit(self, 'working')
	
func physics_update(_delta: float) -> void:
	character.move_with_vel()

func _on_timeout() -> void:
	character.velocity = get_rand_vel()
	
func get_rand_vel() -> Vector2:
	var x = randf_range(-1/2, 1/2)
	var y = randf_range(-1/2, 1/2)
	return Vector2(x, y)
