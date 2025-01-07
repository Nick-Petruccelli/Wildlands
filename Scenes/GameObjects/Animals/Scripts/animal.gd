extends CharacterBody2D
class_name Animal

var animal_id: int = 0
var stats: Dictionary = {
	"health": 60,
	"speed": 30,
}
var move_dir: Vector2
var move_dir_last_change: int = 0
var paniced: bool = false

func _ready() -> void:
	move_dir = get_rand_dir()
	
func _physics_process(delta: float) -> void:
	if !paniced:
		wander()
	else:
		pass

func wander() -> void:
	if Time.get_ticks_msec() - move_dir_last_change > 2000:
		move_dir = get_rand_dir()
		move_dir_last_change = Time.get_ticks_msec()
	velocity  = move_dir * stats["speed"]
	#print(move_dir)
	move_and_slide()
	
func take_damage(damage: int) -> void:
	stats["health"] -= damage
	paniced = true

func is_dead() -> bool:
	return stats["health"] <= 0

func get_rand_dir() -> Vector2:
	var x = randf_range(-.25, .25)
	var y = randf_range(-.25, .25)
	print(x, y)
	return Vector2(x, y)
