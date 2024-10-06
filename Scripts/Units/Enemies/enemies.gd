extends Node2D

signal increase_resources

@export var enemy_scene: PackedScene
@export var spawn_rate: float = 2.0
@export var enemy_speed: float = 100.0

var spawn_timer: float = 0.0
var screen_size: Vector2  # To hold the screen size

func _ready() -> void:
	screen_size = get_viewport_rect().size  # Get the size of the viewport (screen)
	set_process(true)  # Enable the _process function


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer += delta

	# Spawn enemies every `spawn_rate` seconds
	#if spawn_timer >= spawn_rate:
	#	spawn_enemy(Vector2(0,0))
	#	spawn_timer = 0.0
		
	for spawner in get_parent().get_node("Spawners").get_children():
		if spawner.can_spawn():
			spawn_enemy(spawner.position)
		
func spawn_enemy(pos: Vector2):
	var main = get_parent()
	main.total_enemies += 1
	
	# Create an instance of the enemy scene
	var enemy = enemy_scene.instantiate()

	# Randomly choose an edge to spawn the enemy
	var spawn_position = pos

	# Set the enemy's position at the spawn point
	enemy.position = spawn_position

	# Add the enemy to the scene tree
	add_child(enemy)

	# Move the enemy towards the mouse position (handled in the enemy script)
	set_target(enemy)
	
	enemy.on_death.connect(on_death_of_enemy)

func set_target(enemy) -> void:
	if !enemy or !is_instance_valid(enemy):
		return
	
	var closest_wall = null
	var closest = 99999999
	
	var main = get_parent()
	var walls = []
	
	if !main or !is_instance_valid(main):
		return
	
	for key in main.building_dictionary:
		var wall = main.building_dictionary[key]
		if !wall or !is_instance_valid(wall):
			continue
			
		if main.building_dictionary[key].building_type != "MeatWall":
			continue
		walls.append(key)
		
	var local_pos = main.get_node("TileMapLayer").local_to_map(enemy.position)
	
	for wall in walls:
		var manhattan = abs(wall.x - local_pos.x) + abs(wall.y - local_pos.y)
		if manhattan < closest:
			closest = manhattan
			closest_wall = main.building_dictionary[wall]
			
	if closest_wall:
		enemy.target = closest_wall
		enemy.target_position = closest_wall.position

func get_random_edge_position() -> Vector2:
	# Choose a random edge: 0 = top, 1 = right, 2 = bottom, 3 = left
	var edge = randi() % 4
	var position = Vector2()

	match edge:
		0:  # Top edge
			position.x = randf() * screen_size.x
			position.y = 0
		1:  # Right edge
			position.x = screen_size.x
			position.y = randf() * screen_size.y
		2:  # Bottom edge
			position.x = randf() * screen_size.x
			position.y = screen_size.y
		3:  # Left edge
			position.x = 0
			position.y = randf() * screen_size.y

	return position
	
func on_death_of_enemy() -> void:
	get_parent().total_enemies -= 1
	increase_resources.emit()
