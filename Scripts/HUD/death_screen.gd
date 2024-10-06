extends CanvasLayer

var TITLE_SCREEN = preload("res://Levels/TitleScreen.tscn")
var button_pressed = false

var blur = 0;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$YouDied.material.set("shader_param/opacity", blur)
	$BlackBackground.material.set("shader_param/opacity", blur)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	blur += delta * 0.5
	$YouDied.material.set("shader_param/opacity", blur)
	$BlackBackground.material.set("shader_param/opacity", blur * 0.5)
	
	if blur > 1 and !button_pressed:
		if Input.is_anything_pressed():
			for child in get_tree().root.get_children():
				child.queue_free()
			get_tree().root.add_child(TITLE_SCREEN.instantiate())
			button_pressed = true
