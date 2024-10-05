extends Node2D

var velocity = Vector2.ZERO
@export var speed = 500.0

func _process(delta):
	position += velocity * delta
	
	if position.x < -1000 or position.x > get_viewport_rect().size.x or position.y < -1000 or position.y > get_viewport_rect().size.y:
		queue_free()
