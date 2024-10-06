extends Node

var placing_tiles = false
var placing_turrets = false
@export var wall_placed = false
var placing_houses = false

const WALL_PRICE_BONE = 30
const WALL_PRICE_MEAT = 50
const WALL_PRICE_SKIN = 12

const TURRET_PRICE_BONE = 45
const TURRET_PRICE_MEAT = 25
const TURRET_PRICE_SKIN = 0

const HOUSE_PRICE_BONE = 10
const HOUSE_PRICE_MEAT = 10
const HOUSE_PRICE_SKIN = 50

const MEAT_WALL = preload("res://Structures/Walls/MeatWall.tscn")
const TURRET = preload("res://Unit/Turret.tscn")
const HOUSE = preload("res://Unit/Spawners/ScroteHouse.tscn")

#TODO: Change these values
const SKIN_GAINED = 10
const BONES_GAINED = 10
const MEAT_GAINED = 10

const MAX_ENEMIES = 200
@export var total_enemies = 0

@export var game_over = false

var building_dictionary = {}

func UpdateHighlight():
	var mousePos = $TileMapLayer.get_global_mouse_position()
	var mapPos =  $TileMapLayer.local_to_map(mousePos)
	if(placing_tiles):
		mapPos = get_fortress_corner_from_map_pos(mapPos) + Vector2i(2,2)
	var tilePos =  $TileMapLayer.map_to_local(mapPos)
	$TileHighlight.position = tilePos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	UpdateHighlight()
	
	if placing_tiles and Input.is_action_just_pressed("ui_cancel"):
		set_placing_tiles(false)
		placing_turrets = false
		placing_houses = false#
	
	if Input.is_action_just_pressed("ui_click"):
		if placing_tiles:
			attempt_place_fortress()
		elif placing_turrets:
			attempt_place_building(TURRET, TURRET_PRICE_BONE, TURRET_PRICE_SKIN, TURRET_PRICE_MEAT, true)
		elif placing_houses:
			attempt_place_building(HOUSE, HOUSE_PRICE_BONE, HOUSE_PRICE_SKIN, HOUSE_PRICE_MEAT)

func get_fortress_corner_from_map_pos(mapPos: Vector2i):
	return (mapPos - (mapPos % 5))
	
func attempt_place_fortress():	
	var mousePos = $TileMapLayer.get_global_mouse_position()
	var mapPos =  $TileMapLayer.local_to_map(mousePos)
	
	# Make sure there isn't already a fortress there
	if $TileMapLayer.get_cell_atlas_coords(mapPos) == Vector2i(0,0):
		return
	
	if $MainHud.bones < WALL_PRICE_BONE:
		return
	if $MainHud.meat < WALL_PRICE_MEAT:
		return
	if $MainHud.skin < WALL_PRICE_SKIN:
		return
		
	wall_placed = true
		
	$MainHud.increase_bones(-WALL_PRICE_BONE)
	$MainHud.increase_meat(-WALL_PRICE_MEAT)
	$MainHud.increase_skin(-WALL_PRICE_SKIN)
	
	mapPos = get_fortress_corner_from_map_pos(mapPos)
	for i in 5:
		for j in 5:
			var tilePos = mapPos + Vector2i(i, j);
			$TileMapLayer.set_cell(tilePos, 0, Vector2i(0,0))
			if i == 0 or i == 4 or j == 0 or j == 4:
				if !building_dictionary.has(tilePos):
					var wall = MEAT_WALL.instantiate();
					wall.position = $TileMapLayer.map_to_local(tilePos) + Vector2(0, -64)
					building_dictionary[tilePos] = wall
					add_child(wall)
	check_wall_adjecency()
	set_placing_tiles(false)
	
	
	var fortress_min = Vector2(mapPos)
	var fortress_max = Vector2(mapPos)+Vector2(5,5)
	delete_spawner_here(Rect2(fortress_min, fortress_max))
	
	

func attempt_place_building(building_resource: Resource, bone_price: float, skin_price: float, meat_price: float, is_turret: bool = false):
	var mousePos = $TileMapLayer.get_global_mouse_position()
	var mapPos =  $TileMapLayer.local_to_map(mousePos)
	
	if building_dictionary.has(mapPos):
		return
		
	if $TileMapLayer.get_cell_atlas_coords(mapPos) != Vector2i(0,0):
		return
	if $MainHud.bones < bone_price:
		return
	if $MainHud.meat < meat_price:
		return
	if $MainHud.skin < skin_price:
		return
		
	$MainHud.increase_bones(-bone_price)
	$MainHud.increase_meat(-meat_price)
	$MainHud.increase_skin(-skin_price)
	
	var building = building_resource.instantiate()
	building.position = $TileMapLayer.map_to_local(mapPos)
	if(is_turret):
		$Turrets.add_child(building)
	else:
		add_child(building)
		$Camera2D/HouseNoise.play()
		
	building_dictionary[building.position] = building

func check_wall_adjecency():
	var walls_to_destroy = []
	for key in building_dictionary:
		if building_dictionary[key].building_type != "MeatWall":
			continue
		var to_keep = false;
		for i in 3:
			for j in 3:
				to_keep = to_keep or $TileMapLayer.get_cell_atlas_coords(key + Vector2i(j - 1, i - 1)) == null or $TileMapLayer.get_cell_atlas_coords(key + Vector2i(j - 1, i - 1)) != Vector2i(0,0);
		
		if !to_keep:
			walls_to_destroy.append(key)
	
	for key in walls_to_destroy:
		var wall = building_dictionary[key]
		building_dictionary.erase(key)
		wall.queue_free()
		$MainHud.increase_bones(randi_range(0,2))
		$MainHud.increase_meat(randi_range(0,2))

func set_placing_tiles(in_placing_tiles: bool):
	placing_tiles = in_placing_tiles
	var scale = 1;
	if placing_tiles:
		scale = 5
	$TileHighlight.scale = Vector2(scale, scale)

func _on_main_hud_tower_selected() -> void:
	set_placing_tiles(!placing_tiles)
	placing_turrets = false
	placing_houses = false

func _on_pause_menu_quit_to_main() -> void:
	queue_free()


func _on_main_hud_turret_selected() -> void:
	set_placing_tiles(false)
	placing_turrets = true
	placing_houses = false	

func _on_main_hud_house_selected() -> void:
	set_placing_tiles(false)
	placing_turrets = false
	placing_houses = true

func _on_enemies_increase_resources() -> void:
	$MainHud.increase_bones(BONES_GAINED)
	$MainHud.increase_meat(MEAT_GAINED)
	$MainHud.increase_skin(SKIN_GAINED)
	
func delete_spawner_here(bounds: Rect2) -> void:
	var spawners = $Spawners.get_children()
	for spawner in spawners:
		var spawner_col_shape: CollisionShape2D = spawner.get_node("CollisionShape2D")
		var spawner_scale = spawner_col_shape.scale*0.5
		var spawner_bounds_min = (spawner.position/128.0)-Vector2(2, 1)
		var spawner_bounds_max = (spawner.position/128.0)+Vector2(2, 1)
		
		var spawner_bounds = Rect2(spawner_bounds_min, spawner_bounds_max)
		
		if rects_overlap(spawner_bounds, bounds):
		#if spawner_bounds.intersects(bounds):
			spawner.queue_free()
			
func rects_overlap(a: Rect2, b: Rect2) -> bool:
	if(a.position.x > b.size.x
		or b.position.x > a.size.x
		or a.position.y > b.size.y
		or b.position.y > a.size.y):
			return false
	
	return true
		
	
	
	

	
