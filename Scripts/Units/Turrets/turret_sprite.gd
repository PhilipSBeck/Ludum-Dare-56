extends AnimatedSprite2D

func _ready() -> void:
	$".".play("default")

func _process(delta):
	var enemy_pos = get_parent().get_target()
	
	var direction = enemy_pos - global_position
	var angle_to_mouse = direction.angle() + PI / 2

	rotation = angle_to_mouse
