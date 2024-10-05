extends Node2D

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
	
	for enemy in get_children():
		set_target(enemy)

	# Spawn enemies every `spawn_rate` seconds
	if spawn_timer >= spawn_rate:
		spawn_enemy()
		spawn_timer = 0.0
		
func spawn_enemy():
	# Create an instance of the enemy scene
	var enemy = enemy_scene.instantiate()

	# Randomly choose an edge to spawn the enemy
	var spawn_position = get_random_edge_position()

	# Set the enemy's position at the spawn point
	enemy.position = spawn_position

	# Add the enemy to the scene tree
	add_child(enemy)

	# Move the enemy towards the mouse position (handled in the enemy script)
	set_target(enemy)

func set_target(enemy) -> void:
	enemy.target_position = get_global_mouse_position()

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
