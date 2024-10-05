extends CanvasLayer

var meat: int = 0
var skin: int = 0
var bones: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func increase_meat(amount: int) -> void:
	meat += amount
	$MeatIcon/Meat.text = str(meat)
	
func increase_skin(amount: int) -> void:
	skin += amount
	$SkinIcon/Skin.text = str(skin)
	
func increase_bones(amount: int) -> void:
	bones += amount
	$BoneIcon/Bones.text = str(bones)
