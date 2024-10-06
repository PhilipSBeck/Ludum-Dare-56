extends ProgressBar  # Or whatever node your object is

var max_health: int = 100
var health: int = 100

# Reference to the ProgressBar node
@onready var parent = get_parent()

func _ready():
	max_health = parent.MAX_HEALTH
	health = parent.health
	# Set the initial values for the health bar
	max_value = max_health
	update_health_bar()  # Ensure the health bar is initialized with correct health

func _process(_delta: float):
	health = parent.health
	update_health_bar()  # Ensure the health bar is updated every frame

	# Show or hide health bar based on health levela
	# Optional: Adjust this based on whether you want to hide it at full health or not
	if health == max_health:
		visible = false
	else:
		visible = true

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
	# Update the health bar's value
	value = health

func die():
	# Handle object death
	queue_free()  # Example action, you can customize this
