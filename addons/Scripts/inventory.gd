extends Control

@onready var slotScene = preload("res://Scenes/slot.tscn")
@onready var gridContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var itemScene = preload("res://Scenes/item.tscn")
@onready var scrollContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer
@onready var colCount = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/GridContainer.columns
@onready var inventoryMenu = $"."

var gridArray = []
var itemHeld = null
var currentSlot = null
var canPlace = false
var iconAnchor : Vector2

func _ready():
	for i in range(64):
		createSlot()
		
	inventoryMenu.hide()
	
func _process(delta):
	
	if itemHeld:
	#TODO: but might wanna add it to here -- if scrollContainer.get_global_rect().hasPoint(get_global_mouse_position()):	
		if Input.is_action_just_pressed("rotateItem"):
			_rotate_item()
		
		if Input.is_action_just_pressed("placeItem"):
			if scrollContainer.get_global_rect().has_point(get_global_mouse_position()):
				_place_item()
	
	#TODO: might wanna change this to pick up outer items to add into inventory -- if scrollContainer.get_global_rect().hasPoint(get_global_mouse_position()):
	else:
		if Input.is_action_just_pressed("placeItem"):
			if scrollContainer.get_global_rect().has_point(get_global_mouse_position()):
				_pickup_item()
				
func createSlot():
	var newSlot = slotScene.instantiate()
	newSlot.slot_ID = gridArray.size()
	gridContainer.add_child(newSlot)
	gridArray.push_back(newSlot)
	newSlot.slot_entered.connect(_on_slot_mouse_entered)
	newSlot.slot_exited.connect(_on_slot_mouse_exited)
	
func _on_slot_mouse_entered(a_Slot):
	iconAnchor = Vector2(10000,100000)
	currentSlot = a_Slot
	if itemHeld:
		_check_slot_availability(currentSlot)
		_setGrids.call_deferred(currentSlot)
		

func _on_slot_mouse_exited(a_Slot):
	_clear_grid()


func _on_button_spawn_pressed():
	var newItem = itemScene.instantiate()
	add_child(newItem)
	newItem._loadItem(2)
	newItem.selected = true
	itemHeld = newItem

func _on_discard_pressed():
	if itemHeld:
		itemHeld.remove_child(itemHeld)



	
func _check_slot_availability(a_Slot):
	for grid in itemHeld.itemGrids:
		print(itemHeld.itemGrids)
		var gridToCheck = a_Slot.slot_ID + grid[0] + grid[1] * colCount
		print(gridToCheck)
		var lineSwitchCheck = a_Slot.slot_ID % colCount + grid[0]
		if lineSwitchCheck < 0 or lineSwitchCheck >= colCount:
			canPlace = false
			return
		if gridToCheck < 0 or gridToCheck >= gridArray.size():
			canPlace = false
			return
		if gridArray[gridToCheck].state == gridArray[gridToCheck].States.TAKEN:
			canPlace = false
			return
	canPlace = true 
	

func _setGrids(a_Slot):
	for grid in itemHeld.itemGrids:
		var gridToCheck = a_Slot.slot_ID + grid[0] + grid[1] * colCount
		if gridToCheck < 0 or gridToCheck >= gridArray.size():
			continue
			var lineSwitchCheck = a_Slot.slot_ID % colCount + grid[0]
			if lineSwitchCheck < 0 or lineSwitchCheck >= colCount:
				continue
		
		if canPlace:
			gridArray[gridToCheck]._set_color(gridArray[gridToCheck].States.FREE)
			
			if grid[1] < iconAnchor.x: iconAnchor.x = grid[1]
			if grid[0] < iconAnchor.y: iconAnchor.y = grid[0]
			
		else:
			gridArray[gridToCheck]._set_color(gridArray[gridToCheck].States.TAKEN)

func _clear_grid():
	for grid in gridArray:
		grid._set_color(grid.States.DEFAULT)

func _rotate_item():
	itemHeld._rotate_item()
	_clear_grid()
	if currentSlot:
		_on_slot_mouse_entered(currentSlot)
		
func _place_item():
	if not canPlace or not currentSlot:
		return
	
	var calculatedGridId = currentSlot.slot_ID + iconAnchor.x * colCount + iconAnchor.y
	itemHeld._snap_to(gridArray[calculatedGridId].global_position)
	
	itemHeld.get_parent().remove_child(itemHeld)
	gridContainer.add_child(itemHeld)
	itemHeld.global_position = get_global_mouse_position()
	
	itemHeld.gridAnchor = currentSlot
	for grid in itemHeld.itemGrids:
		var gridToCheck = currentSlot.slot_ID + grid[0] + grid[1] * colCount
		gridArray[gridToCheck].state = gridArray[gridToCheck].States.TAKEN
		gridArray[gridToCheck].itemStored = itemHeld
	
	itemHeld = null
	_clear_grid()

func _pickup_item():
	if not currentSlot or not currentSlot.itemStored:
		return
	itemHeld = currentSlot.itemStored
	itemHeld.selected = true
	
	itemHeld.get_parent().remove_child(itemHeld)
	add_child(itemHeld)
	itemHeld.global_position = get_global_mouse_position()
	
	for grid in itemHeld.itemGrids:
		var gridToCheck = itemHeld.gridAnchor.slot_ID + grid[0] + grid[1] * colCount
		gridArray[gridToCheck].state = gridArray[gridToCheck].States.FREE
		gridArray[gridToCheck].itemStored = null
	
	_check_slot_availability(currentSlot)
	_setGrids.call_deferred(currentSlot)
