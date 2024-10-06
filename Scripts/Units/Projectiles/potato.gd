extends Area2D

@export var target: Node2D = null
var last_pos: Vector2 = Vector2(0, 0)
@export var speed: float = 250.0
var spin_speed: float = 0
var damage: int = 1

func _ready():
	target = get_parent().get_target()
	last_pos = target.position
	spin_speed = randf_range(-10, 10)

func _process(delta: float):
	if target and is_instance_valid(target):
		last_pos = target.position
	
	var direction = (last_pos - global_position).normalized()
	position += direction * speed * delta
	rotation += spin_speed * delta
	# rotation = direction.angle()
	
	# Optional: Remove the potato if it reaches its target
	print(global_position.distance_to(last_pos))
	if global_position.distance_to(last_pos) < 10:
		if target and is_instance_valid(target):
			target.health -= damage
		queue_free()
		
