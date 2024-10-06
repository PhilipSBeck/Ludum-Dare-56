extends CanvasLayer

signal towerSelected
signal turretSelected

var meat: int = 200
var skin: int = 200
var bones: int = 200


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MeatIcon/Meat.text = str(meat)
	$SkinIcon/Skin.text = str(skin)
	$BoneIcon/Bones.text = str(bones)


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



func _on_tower_place_btn_hover() -> void:
	$Hotbar/TowerPlaceBtn/Selector.visible = true
	$Hotbar/SelectedIcon.text = $Hotbar/TowerPlaceBtn.get_meta("type")

func _on_tower_place_btn_unhover() -> void:
	$Hotbar/TowerPlaceBtn/Selector.visible = false
	$Hotbar/SelectedIcon.text = ""

func _on_turret_place_btn_mouse_entered() -> void:
	$Hotbar/TurretPlaceBtn/Selector.visible = true
	$Hotbar/SelectedIcon.text = $Hotbar/TurretPlaceBtn.get_meta("type")

func _on_turret_place_btn_mouse_exited() -> void:
	$Hotbar/TurretPlaceBtn/Selector.visible = false
	$Hotbar/SelectedIcon.text = ""


func _on_turret_place_btn_pressed() -> void:
	turretSelected.emit()


func _on_tower_place_btn_pressed() -> void:
	towerSelected.emit()
