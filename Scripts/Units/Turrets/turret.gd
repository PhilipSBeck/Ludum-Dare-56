extends Node2D

@export var potato_scene: PackedScene
@export var fire_rate: float = 0.3
@export var projectile_speed: float = 1000.0
@export var target: Node2D = null

@export var building_type = "Turret"

var last_shot_time: float = 0.0

func _process(delta: float):
	last_shot_time += delta
	target = get_target()

	if target != null and last_shot_time >= fire_rate:
		shoot_potato()
		last_shot_time = 0.0

func shoot_potato():
	var potato = potato_scene.instantiate()
	add_child(potato)
	potato.z_index = 100
	
	potato.position = Vector2(0, 0)
	
	var direction = (target.position - position).normalized()
	potato.target = target
	
func get_target() -> Node2D:
	var closest_enemy = null
	var closest = 999999
	
	for enemy in get_parent().get_parent().get_node("Enemies").get_children():
		var dist = abs(enemy.position.x - position.x) + abs(enemy.position.y - position.y)
		
		if dist < closest:
			closest = dist
			closest_enemy = enemy
			
	return closest_enemy
