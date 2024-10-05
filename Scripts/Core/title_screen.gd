extends Node

var main_scene = preload("res://Levels/main.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_title_screen_start_button_pressed() -> void:
	get_tree().root.add_child(main_scene)
	get_node("/root/TitleScreen").queue_free()
	pass # Replace with function body.
