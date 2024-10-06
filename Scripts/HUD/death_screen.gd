extends CanvasLayer

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
	pass
