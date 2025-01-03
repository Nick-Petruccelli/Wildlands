extends Camera2D

@export var speed: float = 10.0
@export var zoom_speed: float = 5.0
@export var min_zoom: float = 1.5
@export var max_zoom: float = 3.0

var target: Vector2

func _ready() -> void:
	target = global_position


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_camera_right"):
		target += Vector2(speed, 0)
	if Input.is_action_pressed("move_camera_left"):
		target += Vector2(-speed, 0)
	if Input.is_action_pressed("move_camera_up"):
		target += Vector2(0, -speed)
	if Input.is_action_pressed("move_camera_down"):
		target += Vector2(0, speed)
	global_position = global_position.lerp(target, delta * speed)
	if Input.is_action_just_released("zoom_camera_in"):
		if zoom.x < max_zoom:
			zoom += Vector2(zoom_speed, zoom_speed)*delta
	if Input.is_action_just_released("zoom_camera_out"):
		if zoom.x > min_zoom:
			zoom -= Vector2(zoom_speed, zoom_speed)*delta
