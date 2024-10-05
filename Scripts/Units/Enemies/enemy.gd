extends Node2D

signal on_death

@onready var sprite = $AnimatedSprite2D  # Assuming the sprite is a child of the Node2D
var target_position: Vector2 = Vector2.ZERO
@export var speed: float = 100.0

func _process(delta: float):
	# Calculate the direction to the mouse position
	var direction = (target_position - position).normalized()

	# Move towards the target position
	position += direction * speed * delta

	# Check if the enemy is moving to the left (i.e., the x component of direction is negative)
	if direction.x < 0:
		sprite.flip_h = true  # Flip the sprite horizontally
	else:
		sprite.flip_h = false  # Ensure it's not flipped if moving right

	# Optionally, free the enemy when it reaches the target (to prevent it from moving indefinitely)
	if position.distance_to(target_position) < 10:
		queue_free()
