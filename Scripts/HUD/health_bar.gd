extends Node2D  # Or whatever node your object is

var max_health: int = 100
var health: int = 100

# Reference to the ProgressBar node
@onready var health_bar = $ProgressBar

func _ready():
	var parent = get_parent()
	max_health = parent.MAX_HEALTH
	health = parent.health
	# Set the initial values for the health bar
	health_bar.max_value = max_health
	health_bar.value = health

func _process(_delta: float):
	if health == max_health:
		health_bar.visible = false
	else:
		health_bar.visible = true

func take_damage(amount: int):
	health -= amount
	if health < 0:
		health = 0  # Ensure health doesn't drop below 0
	update_health_bar()

	if health == 0:
		die()

func heal(amount: int):
	health += amount
	if health > max_health:
		health = max_health  # Ensure health doesn't exceed max
	update_health_bar()

func update_health_bar():
	health_bar.value = health

func die():
	# Handle object death
	queue_free()  # Example action, you can customize this
