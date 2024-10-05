extends Camera2D

var camera_speed = 200
var border_margin = 20
var mouse_edge_speed: float = 2.0

func _process(delta: float):
	var movement := Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		movement.y -= 1
	if Input.is_action_pressed("ui_down"):
		movement.y += 1
	if Input.is_action_pressed("ui_left"):
		movement.x -= 1
	if Input.is_action_pressed("ui_right"):
		movement.x += 1

	movement = movement.normalized() * camera_speed * delta

	position += movement
