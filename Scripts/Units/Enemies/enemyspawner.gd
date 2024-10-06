extends Node2D

@export var spawnRate : float = 1.0
@export var enemiesPerSpawn: int = 1
@export_enum("All") var enemy_type: int
	
var timeSinceLastSpawn: float = 0.0

func _process(delta: float) -> void:
	timeSinceLastSpawn += delta
	
func can_spawn() -> bool:
	var can_spawn_en: bool = spawnRate <= timeSinceLastSpawn
	var main = get_parent().get_parent()
	can_spawn_en = can_spawn_en and main.total_enemies < main.MAX_ENEMIES
	can_spawn_en = can_spawn_en and main.wall_placed
	
	if can_spawn_en:
		timeSinceLastSpawn = 0.0
		
	return can_spawn_en

func get_spawn_rate() -> float:
	return spawnRate
	
func get_enemies_per_spawn() -> int:
	return enemiesPerSpawn
	
func increse_enemies_per_spawn(amount: int) -> void:
	enemiesPerSpawn += amount
	
func getTimeSinceLastSpawn() -> float:
	return timeSinceLastSpawn
	
#func get_enemy_type 
