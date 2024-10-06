extends StaticBody2D

@export var building_type = "Structure Name"
@export var health = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health <= 0:
		var death_screen = load("res://Levels/DeathScreen.tscn")
		var game_over = get_node("/root/Main").game_over
		
		if death_screen and !game_over:
			get_node("/root/Main").game_over = true
			get_tree().change_scene_to_packed(death_screen)
			get_node("/root/Main/MainHud").queue_free()
		else:
			print("OH NOOOOO")
		
		queue_free()
