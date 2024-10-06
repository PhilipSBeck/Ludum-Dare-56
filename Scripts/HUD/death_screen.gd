extends CanvasLayer

var TITLE_SCREEN = preload("res://Levels/TitleScreen.tscn")
var button_pressed = false

var auto_transition_counter = 10.0
var blur = 0;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$YouDied.material.set("shader_param/opacity", blur)
	$BlackBackground.material.set("shader_param/opacity", blur)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	auto_transition_counter -= delta
	
	blur += delta * 0.5
	$YouDied.material.set("shader_param/opacity", blur)
	$BlackBackground.material.set("shader_param/opacity", blur * 0.5)
	
	if (blur > 1 and !button_pressed and Input.is_anything_pressed()) or auto_transition_counter < 0:
		back_to_title()

func back_to_title():
	for child in get_tree().root.get_children():
		child.queue_free()
	get_tree().root.add_child(TITLE_SCREEN.instantiate())
	button_pressed = true
