extends Node

var itemData = {}
var itemGridData = {}
@onready var itemDataPath = "res://Data/ItemData.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_data(itemDataPath)
	_set_grid_data()
	
func _load_data(path : String) -> void:
	if not FileAccess.file_exists(path):
		print("Item data file not found")
	var itemDataFile = FileAccess.open(path, FileAccess.READ)
	itemData = JSON.parse_string(itemDataFile.get_as_text())
	itemDataFile.close()
	
func _set_grid_data() -> void:
	for item in itemData.keys():
		var tempGridArray = []
		for point in itemData[item]["Grid"].split("/"):
			tempGridArray.append(point.split(","))
		itemGridData[item] = tempGridArray
