extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_animation("Enemy" + str(randi_range(1,3)))
	$".".play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
