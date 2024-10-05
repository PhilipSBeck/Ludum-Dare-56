extends CanvasLayer

signal quit_to_main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().paused = true
		visible = true


func _on_start_button_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	quit_to_main.emit()
	get_tree().change_scene_to_file("res://Levels/TitleScreen.tscn")
