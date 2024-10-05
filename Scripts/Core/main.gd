extends Node

var placing_tiles = false

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
			$TileMapLayer.set_cell(mapPos + Vector2i(i, j), 0, Vector2i(0,0))

func set_placing_tiles(in_placing_tiles: bool):
	placing_tiles = in_placing_tiles
	var scale = 1;
	if placing_tiles:
		scale = 5
	$TileHighlight.scale = Vector2(scale, scale)

func _on_main_hud_tower_selected() -> void:
	set_placing_tiles(!placing_tiles)
