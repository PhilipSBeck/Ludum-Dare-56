extends RigidBody2D

var target = null
@export var speed: float = 150.0
@onready var sprite = $AnimatedSprite2D
var waiting = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.set_animation("stand")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if waiting:
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
	
	if (target.position - position).length_squared() < 50:
		target = 0
		linear_velocity = Vector2.ZERO#
		waiting = true
		sprite.set_animation("stand")
		$RepathTimer.stop()
		$WaitTimer.start()

func get_new_target():
	var turrets = get_parent().get_parent().get_node("Turrets").get_children()
	if turrets.size() > 0:
		target = turrets[randi_range(0,turrets.size()-1)]


func _on_wait_timer_timeout() -> void:
	waiting = false


func _on_repath_timer_timeout() -> void:
	get_new_target()
