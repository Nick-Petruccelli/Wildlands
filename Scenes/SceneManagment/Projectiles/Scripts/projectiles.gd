extends Node2D

func add(proj_id: int, pos: Vector2, direction: Vector2, wep_dam: int, accuracy: int) -> void:
	var projectile = preload("res://Scenes/SceneManagment/Projectiles/projectile.tscn").instantiate()
	add_child(projectile)
	projectile.init(proj_id, pos, direction, wep_dam, accuracy)
	print("add projectile add")
