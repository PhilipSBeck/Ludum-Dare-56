extends Node

func UpdateHighlight():
	var mousePos = $TileMapLayer.get_global_mouse_position()
	var mapPos =  $TileMapLayer.local_to_map(mousePos)
	var tilePos =  $TileMapLayer.map_to_local(mapPos)
	$TileHighlight.position = tilePos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	UpdateHighlight()
