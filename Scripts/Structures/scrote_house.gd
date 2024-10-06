extends Area2D

@export var building_type = "House"

const SCROTE = preload("res://Unit/Scrote.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scrote = SCROTE.instantiate()
	scrote.position = position
	get_parent().get_node("Scrotes").add_child(scrote)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
