extends TileMapLayer

@export_group("Spawner Options")
@export var spawner_scene: PackedScene
@export var no_of_spawners: int = 100
@export var minSpawnerRateRange: float = 1.0
@export var maxSpawnerRateRange: float = 5.0
@export var minEnemiesPerSpawn: int = 1
@export var maxEnemiesPerSpawn: int = 3

var positions_used: Array[Vector2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	
	for i in 100:
		for j in 100:
			set_cell(Vector2i(i, j), 0, Vector2i(rng.randi_range(1,3),0))
			
	var tile_size = tile_set.tile_size
	for i in no_of_spawners:
		var spawner = spawner_scene.instantiate()
		var pos = Vector2(randi_range(0,100), randi_range(0,100))
		pos*=Vector2(tile_size)
		#while check_if_spawner_already_at_pos(pos):
		#	pos = Vector2(randf_range(0,100), randf_range(0,100))*Vector2(tile_size)
		
		spawner.position = pos
		spawner.spawnRate = randf_range(minSpawnerRateRange, maxSpawnerRateRange)
		spawner.enemiesPerSpawn = randi_range(minEnemiesPerSpawn, maxEnemiesPerSpawn)
		get_parent().get_node("Spawners").add_child(spawner)
		
		positions_used.append(pos)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func check_if_spawner_already_at_pos(pos: Vector2) -> bool:
	var current_spawners = get_parent().get_node("Spawners").get_children()
	for spawner in current_spawners:
		var spawner_pos = spawner.position
		var spawner_col_shape: CollisionShape2D = spawner.get_node("CollisionShape2D")
		var spawner_scale = spawner_col_shape.scale/2
		
		var spawner_bounds_min = spawner_pos - spawner_scale
		var spawner_bounds_max = spawner_pos + spawner_scale
		
		if pos >= spawner_bounds_min or pos <= spawner_bounds_max:
			return true
		
	return false
		
