extends Area2D

signal on_death

@onready var sprite = $AnimatedSprite2D  # Assuming the sprite is a child of the Node2D
var target_position: Vector2 = Vector2.ZERO
@export var speed: float = 100.0
@export var health: int = 5
@export var MAX_HEALTH: int = 5
@export var target: Node2D = null
var time_since_reaching_target = 0.0
var damage_dealt = 0

func _process(delta: float):
	if health <= 0:
		on_death.emit()
		queue_free()
		
	var collision_x = $CollisionShape2D.shape.extents.x
	var collision_y = $CollisionShape2D.shape.extents.y
	
	var pos_y = target_position.y + 64
		
	var dist_x = abs(target_position.x - position.x)
	var dist_y = abs(pos_y - position.y)
	var width = collision_x * $AnimatedSprite2D.scale.x + 64
	var height = collision_y * $AnimatedSprite2D.scale.y + 64
	
	if dist_x < width and dist_y < height:
		# Damage the targetted wall as enemy is touching
		if target and is_instance_valid(target):
			time_since_reaching_target += delta
			if time_since_reaching_target - damage_dealt >= 1.0:
				damage_dealt += 1
				target.health -= 1
				$AudioStreamPlayer2D.play()
		
		return
	
	# Calculate the direction to the mouse position
	var direction = (target_position - position).normalized()

	var velocity = direction * speed * delta

	# Move towards the target position
	position += velocity

	# Check if the enemy is moving to the left (i.e., the x component of direction is negative)
	if direction.x < 0:
		sprite.flip_h = true  # Flip the sprite horizontally
	else:
		sprite.flip_h = false  # Ensure it's not flipped if moving right

	# Optionally, free the enemy when it reaches the target (to prevent it from moving indefinitely)
	# if position.distance_to(target_position) < 10:
	# 	queue_free()
