extends Node2D

@onready var IconRectPath = $Icon

var itemID : int
var itemGrids = []
var selected = false
var gridAnchor = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		
func _loadItem(a_ItemID: int) -> void:
	var IconPath = "res://Visual Resources/" + DataHandler.itemData[str(a_ItemID)]["Name"] + ".png"
	IconRectPath.texture = load(IconPath)
	for grid in DataHandler.itemGridData[str(a_ItemID)]:
		var converterArray := []
		for i in grid:
			converterArray.append(int(i))
		itemGrids.append(converterArray)
		
func _rotate_item():
	for grid in itemGrids:
		var tempY = grid[0]
		grid[0] = -grid[1]
		grid[1] = tempY
	rotation_degrees += 90
	if rotation_degrees >= 360:
		rotation_degrees = 0
		
func _snap_to(destination:Vector2):
	var tween = get_tree().create_tween()
	if int(rotation_degrees) % 180 == 0:
		destination += IconRectPath.size/2
	else:
		var tempXySwitch = Vector2(IconRectPath.size.y, IconRectPath.size.x)
		destination += IconRectPath.size/2
	
	tween.tween_property(self, "global_position", destination, 0.15).set_trans(Tween.TRANS_SINE)
	selected = false
