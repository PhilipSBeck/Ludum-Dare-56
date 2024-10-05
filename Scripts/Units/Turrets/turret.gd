extends Node2D

@export var potato_scene: PackedScene
@export var fire_rate: float = 0.1
@export var projectile_speed: float = 500.0

var last_shot_time: float = 0.0

func _process(delta: float):
	last_shot_time += delta

	if Input.is_action_just_pressed("ui_click") and last_shot_time >= fire_rate:
		shoot_potato()
		last_shot_time = 0.0

func shoot_potato():
	var potato = potato_scene.instantiate()
	add_child(potato)
	potato.z_index = 100
	
	potato.position = Vector2(0, 0)
	
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - $".".position).normalized()
	potato.velocity = direction * projectile_speed
	potato.rotation = direction.angle()
