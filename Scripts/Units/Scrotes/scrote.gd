extends RigidBody2D

var target = null
@export var speed: float = 150.0
@export var repairAmount: float = 5
@onready var sprite = $AnimatedSprite2D
var waiting = false
var repairCounter = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.set_animation("stand")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if waiting:
		repairCounter -= delta
		if is_instance_valid(target) and repairCounter < 0:
			repairCounter = 1.0
			var full_health = target.addHealth(repairAmount)
			if full_health:
				$WaitTimer.stop()
				target = 0
				waiting = false
		return
	
	if !target:
		get_new_target()
		$RepathTimer.start()

	if !target:
		if(sprite.get_animation() != "stand"):
			sprite.set_animation("stand")
		return
		
	if(sprite.get_animation() != "walk"):
		sprite.set_animation("walk")
	
	var direction = (target.position - position).normalized()
	linear_velocity = direction * speed
	
	if linear_velocity.x < 0:
		sprite.flip_h = true  # Flip the sprite horizontally
	else:
		sprite.flip_h = false 
	
	if (target.position - position).length() < 200:
		linear_velocity = Vector2.ZERO#
		waiting = true
		sprite.set_animation("stand")
		$RepathTimer.stop()
		$WaitTimer.start()

func get_new_target():
	var buildings = get_parent().get_parent().building_dictionary#.get_node("Turrets").get_children()	
	if !buildings:
		return
	
	var damaged_walls = []
	for key in buildings:
		var building = buildings[key]
		if is_instance_valid(building) and building.building_type == "MeatWall" and building.health < building.MAX_HEALTH:
			damaged_walls.append(building)
	
	if damaged_walls.size() <= 0:
		return
	
	target = damaged_walls[randi_range(0, damaged_walls.size() - 1)]
	#if turrets.size() > 0:
		#target = turrets[randi_range(0,turrets.size()-1)]


func _on_wait_timer_timeout() -> void:
	waiting = false
	get_new_target()


func _on_repath_timer_timeout() -> void:
	get_new_target()
