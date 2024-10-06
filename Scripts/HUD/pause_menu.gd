extends CanvasLayer

signal quit_to_main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused


func _on_start_button_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	quit_to_main.emit()
	get_tree().change_scene_to_file("res://Levels/TitleScreen.tscn")


func _on_h_slider_value_changed(value: float) -> void:
	var effect = AudioServer.get_bus_effect(0,0)
	effect.set_volume_db(linear_to_db(value))
