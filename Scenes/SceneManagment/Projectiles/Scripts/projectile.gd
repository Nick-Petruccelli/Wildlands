extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var id: int = -1
var wep_damage: int = 0
var accuracy: int = 5
var velocity: Vector2

func init(proj_id: int, pos: Vector2, direction: Vector2, wep_dam: int, acc: int) -> void:
	id = proj_id
	wep_damage = wep_dam
	accuracy = acc
	var proj_data = get_tree().get_first_node_in_group("gamedata").item_data[id]["ammo_stats"]
	var projectile_speed = proj_data["speed"]
	velocity = direction * projectile_speed
	var tex = load(proj_data["texture"])
	sprite_2d.texture = tex
	collision_shape_2d.shape.set("size", tex.get_size())
	global_position = pos + sprite_2d.texture.get_size().x * direction
	transform = Transform2D(direction.angle(), pos)
	
func _physics_process(delta: float) -> void:
	global_position += velocity
	check_collision()
	
func check_collision() -> void:
	var collisions = get_overlapping_bodies()
	for body in collisions:
		if body is Animal or Character:
			body.take_damage(wep_damage)
			queue_free()
			return
		hit_environment()
		return

func hit_environment() -> void:
	queue_free()
	return
