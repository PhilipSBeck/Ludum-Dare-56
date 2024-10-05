extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 100:
		for j in 100:
			set_cell(Vector2i(i, j), 0, Vector2i(0,0))
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
