extends Node

var placing_tiles = false

const MEAT_WALL = preload("res://Structures/Walls/MeatWall.tscn")

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
	
	if placing_tiles and Input.is_action_just_pressed("Escape"):
		set_placing_tiles(false)
	if placing_tiles and Input.is_action_just_pressed("ui_click"):
		attempt_place_fortress()

func get_fortress_corner_from_map_pos(mapPos: Vector2i):
	return (mapPos - (mapPos % 5))
	
func attempt_place_fortress():
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

func set_placing_tiles(in_placing_tiles: bool):
	placing_tiles = in_placing_tiles
	var scale = 1;
	if placing_tiles:
		scale = 5
	$TileHighlight.scale = Vector2(scale, scale)

func _on_main_hud_tower_selected() -> void:
	set_placing_tiles(!placing_tiles)
