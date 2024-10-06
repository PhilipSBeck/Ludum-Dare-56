extends Node

var placing_tiles = false
var placing_turrets = false

const WALL_PRICE_BONE = 30
const WALL_PRICE_MEAT = 50
const WALL_PRICE_SKIN = 12

const TURRET_PRICE_BONE = 45
const TURRET_PRICE_MEAT = 25
const TURRET_PRICE_SKIN = 0

const MEAT_WALL = preload("res://Structures/Walls/MeatWall.tscn")
const TURRET = preload("res://Unit/Turret.tscn")

#TODO: Change these values
const SKIN_GAINED = 10
const BONES_GAINED = 10
const MEAT_GAINED = 10


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
	if Input.is_action_just_pressed("ui_click"):
		if placing_tiles:
			attempt_place_fortress()
		elif placing_turrets:
			attempt_place_turret()

func get_fortress_corner_from_map_pos(mapPos: Vector2i):
	return (mapPos - (mapPos % 5))
	
func attempt_place_fortress():
	#TODO check to make sure fortress isn't being added to existing fortress
	
	if $MainHud.bones < WALL_PRICE_BONE:
		return
	if $MainHud.meat < WALL_PRICE_MEAT:
		return
	if $MainHud.skin < WALL_PRICE_SKIN:
		return
	$MainHud.increase_bones(-WALL_PRICE_BONE)
	$MainHud.increase_meat(-WALL_PRICE_MEAT)
	$MainHud.increase_skin(-WALL_PRICE_SKIN)
	
	# TODO this should also add walls and cost something
	var mousePos = $TileMapLayer.get_global_mouse_position()
	var mapPos =  $TileMapLayer.local_to_map(mousePos)
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

func attempt_place_turret():
	var mousePos = $TileMapLayer.get_global_mouse_position()
	var mapPos =  $TileMapLayer.local_to_map(mousePos)

	if $TileMapLayer.get_cell_atlas_coords(mapPos) != Vector2i(0,0):
		return
	if $MainHud.bones < TURRET_PRICE_BONE:
		return
	if $MainHud.meat < TURRET_PRICE_MEAT:
		return
	if $MainHud.skin < TURRET_PRICE_SKIN:
		return
		
	$MainHud.increase_bones(-TURRET_PRICE_BONE)
	$MainHud.increase_meat(-TURRET_PRICE_MEAT)
	$MainHud.increase_skin(-TURRET_PRICE_SKIN)
	
	var turret = TURRET.instantiate()
	turret.position = $TileMapLayer.map_to_local(mapPos)
	$Turrets.add_child(turret)

func check_wall_adjecency():
	var walls_to_destroy = []
	for key in building_dictionary:
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
	placing_turrets = false;


func _on_pause_menu_quit_to_main() -> void:
	queue_free()


func _on_main_hud_turret_selected() -> void:
	set_placing_tiles(false)
	placing_turrets = true;
	pass


func _on_enemies_increase_resources() -> void:
	$MainHud.increase_bones(BONES_GAINED)
	$MainHud.increase_meat(MEAT_GAINED)
	$MainHud.increase_skin(SKIN_GAINED)
