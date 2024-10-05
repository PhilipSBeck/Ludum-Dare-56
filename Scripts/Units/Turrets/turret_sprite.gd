extends AnimatedSprite2D

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	
	var direction = mouse_pos - global_position
	var angle_to_mouse = direction.angle() + PI / 2

	rotation = angle_to_mouse
