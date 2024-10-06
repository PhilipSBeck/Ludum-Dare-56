extends AnimatedSprite2D

func _ready() -> void:
	$".".play("default")

func _process(delta):
	var enemy_pos = get_parent().target
	
	if enemy_pos:
		var direction = enemy_pos.position - global_position
		var angle = direction.angle() + PI / 2

		rotation = angle
