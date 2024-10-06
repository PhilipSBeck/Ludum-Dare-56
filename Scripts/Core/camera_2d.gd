extends Camera2D

var camera_speed = 500
var border_margin = 20
var mouse_edge_speed: float = 2.0

const ZOOM_MULTIPIER: float = 1.2
const MAX_ZOOM: float = 5
const MIN_ZOOM: float = 0.2

func _ready() -> void:
	# hardcoded half the size of the map
	position = Vector2(6400, 6400)
	
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
	
	if Input.is_action_just_pressed("WheelDown"):
		zoom /= ZOOM_MULTIPIER
		var newZoom = maxf(zoom.x, MIN_ZOOM)
		zoom = Vector2(newZoom, newZoom)
	if Input.is_action_just_pressed("WheelUp"):
		zoom *= ZOOM_MULTIPIER
		var newZoom = minf(zoom.x, MAX_ZOOM)
		zoom = Vector2(newZoom, newZoom)
		
	movement = movement.normalized() * camera_speed * (1/zoom.x) * delta

	position += movement
