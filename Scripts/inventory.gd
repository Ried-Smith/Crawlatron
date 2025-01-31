extends Control

#TODO: use new sprites for items, add stats and text to them and shit 
#TODO: add bonus slots on bottom

@onready var slotScene = preload("res://Scenes/slot.tscn")
@onready var gridContainer = $ItemInventory/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var itemScene = preload("res://Scenes/item.tscn")
@onready var scrollContainer = $ItemInventory/MarginContainer/VBoxContainer/ScrollContainer
@onready var colCount = $ItemInventory/MarginContainer/VBoxContainer/ScrollContainer/GridContainer.columns
@onready var inventoryMenu = $"."
@onready var ItemInventory = $ItemInventory
@onready var equipmentInventory = $ColorRect
@onready var itemDropMenu = $ItemDrop
@onready var playerScene = preload("res://Scenes/player.tscn").instantiate()
@onready var leftArmEquipSlot = $ColorRect/LeftArm/LeftArmSprite
@onready var rightArmEquipSlot = $ColorRect/RightArm/RightArmSprite
@onready var leftLegEquipSlot = $ColorRect/LeftLeg/LeftLegSprite
@onready var rightLegEquipSlot = $ColorRect/RightLeg/RightLegSprite
@onready var keyDripSlot = $ItemDrop/TextureRect/TextureRect2/KeyDropSlot
@onready var itemDropSlot = $ItemDrop/TextureRect/TextureRect/ItemDropSlot
@onready var keySlot = $KeyCheck/TextureRect/TextureRect
@onready var keyCheck = $KeyCheck

var gridArray = []
var itemHeld = null
var currentSlot = null
var canPlace = false
var iconAnchor : Vector2
var pickupToGrab = null

func _ready():
	for i in range(32):
		createSlot()
	inventoryMenu.hide()

func _process(delta):
	
		if itemHeld:
			if Input.is_action_just_pressed("rotateItem"):
				_rotate_item()
			
			if Input.is_action_just_pressed("Discard"):
				_delete_item(itemHeld)
			# God this is so fucking ass but it works its fine now
			if Input.is_action_just_pressed("placeItem"):
				if scrollContainer.get_global_rect().has_point(get_global_mouse_position()):
					_place_item()
					

				elif rightArmEquipSlot.get_global_rect().has_point(get_global_mouse_position()):
					if rightArmEquipSlot.texture == null:
						_equip_item(itemHeld, rightArmEquipSlot)
					else:
						print("item already equipped!!")
						
				elif leftArmEquipSlot.get_global_rect().has_point(get_global_mouse_position()):
					if leftArmEquipSlot.texture == null:
						_equip_item(itemHeld, leftArmEquipSlot)
					else:
						print("item already equipped!!")
						
				elif leftLegEquipSlot.get_global_rect().has_point(get_global_mouse_position()):
					if leftLegEquipSlot.texture == null:
						_equip_item(itemHeld, leftLegEquipSlot)
					else:
						print("item already equipped!!")

				elif rightLegEquipSlot.get_global_rect().has_point(get_global_mouse_position()):
					if rightLegEquipSlot.texture == null:
						_equip_item(itemHeld, rightLegEquipSlot)
					else:
						print("item already equipped!!")
				
				elif itemDropSlot.get_global_rect().has_point(get_global_mouse_position()):
					_on_item_grab_pressed()
				
				elif keySlot.get_global_rect().has_point(get_global_mouse_position()):
					_key_unlock(itemHeld)
					

					

		else:
			if Input.is_action_just_pressed("placeItem"):
				if scrollContainer.get_global_rect().has_point(get_global_mouse_position()):
					_pickup_item()
						
				elif leftArmEquipSlot.get_global_rect().has_point(get_global_mouse_position()):
					if !leftArmEquipSlot.texture == null:
						_special_pickup(PlayerVariables.leftArmSlot,leftArmEquipSlot)
						
				elif rightArmEquipSlot.get_global_rect().has_point(get_global_mouse_position()):
					if !rightArmEquipSlot.texture == null:
						_special_pickup(PlayerVariables.rightArmSlot, rightArmEquipSlot)
						
				elif leftLegEquipSlot.get_global_rect().has_point(get_global_mouse_position()):
					if !leftLegEquipSlot.texture == null:
						_special_pickup(PlayerVariables.leftLegSlot, leftLegEquipSlot)
						
				elif rightLegEquipSlot.get_global_rect().has_point(get_global_mouse_position()):
					if !rightLegEquipSlot.texture == null:
						_special_pickup(PlayerVariables.rightLegSlot, rightLegEquipSlot)
			
					
				

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

func _on_death():
	
#item 1: crab claw 20%
#item 2: tesla coil 20%
#item 3: Power piston 20%
#item 4: Extendo-Cordo 20%
#item 5: key
#item 6: red core 5% 
#item 7: blue core 5% 
#item 8: green core 10%

	randomize()
	
	var itemToSpawn = randi() % 100 + 1
	
	if itemToSpawn >= 1 and itemToSpawn <= 20:  
		itemToSpawn = load("res://Visual Resources/ClawArm.png") 
	elif itemToSpawn >= 21 and itemToSpawn <= 40:
		itemToSpawn = load("res://Visual Resources/TeslaT.png")
	elif itemToSpawn >= 41 and itemToSpawn <= 60:
		itemToSpawn = load("res://Visual Resources/PowerPiston.png")
	elif itemToSpawn >= 61 and itemToSpawn <= 80:
		itemToSpawn = load("res://Visual Resources/ExtendoCordo.png")
	elif itemToSpawn >= 81 and itemToSpawn <= 85:
		itemToSpawn = load("res://Visual Resources/BlueCore.png")
	elif itemToSpawn >= 86 and itemToSpawn <= 90:
		itemToSpawn = load("res://Visual Resources/PowerCore.png")
	elif itemToSpawn >= 91 and itemToSpawn <= 100:
		itemToSpawn = load("res://Visual Resources/GreenCore.png")
		
	itemDropMenu.show()
	inventoryMenu.show()
	ItemInventory.show()
	equipmentInventory.hide()
	keyCheck.hide()
	# this texture will be different
	itemDropSlot.texture = itemToSpawn
	keyDripSlot.texture = load("res://Visual Resources/KeyCard.png")
	
	

func _grab_drop(itemToPickup):
	
	itemHeld = itemToPickup
	itemHeld.selected = true
	
	#itemHeld.get_parent().remove_child(itemHeld)
	add_child(itemHeld)
	itemHeld.global_position = get_global_mouse_position()
	
	for grid in itemHeld.itemGrids:
		var gridToCheck = itemHeld.gridAnchor.slot_ID + grid[0] + grid[1] * colCount
		gridArray[gridToCheck].state = gridArray[gridToCheck].States.FREE
		gridArray[gridToCheck].itemStored = null
	
	_check_slot_availability(currentSlot)
	_setGrids.call_deferred(currentSlot)
	
	$ItemDrop/TextureRect/TextureRect/ItemDropSlot.texture = null


func _on_item_grab_pressed():
	var texture = $ItemDrop/TextureRect/TextureRect/ItemDropSlot.texture
	var itemToSpawn
	
	match texture:
		preload("res://Visual Resources/ClawArm.png"):
			itemToSpawn = 1
		preload("res://Visual Resources/TeslaT.png"):
			itemToSpawn = 2
		preload("res://Visual Resources/PowerPiston.png"):
			itemToSpawn = 3
		preload("res://Visual Resources/ExtendoCordo.png"):
			itemToSpawn = 4
		preload("res://Visual Resources/PowerCore.png"):
			itemToSpawn = 5	
		preload("res://Visual Resources/GreenCore.png"):
			itemToSpawn = 6
		preload("res://Visual Resources/BlueCore.png"):
			itemToSpawn = 7


	var newItem = itemScene.instantiate()
	add_child(newItem)
	newItem._loadItem(itemToSpawn)
	newItem.selected = true
	itemHeld = newItem
	
	itemHeld.itemID = itemToSpawn
	
	itemDropSlot.texture = null

func _on_key_grab_pressed():
	var texture = $ItemDrop/TextureRect/TextureRect2/KeyDropSlot.texture
	
	var itemToSpawn = 8
	
	var newItem = itemScene.instantiate()
	add_child(newItem)
	newItem._loadItem(itemToSpawn)
	newItem.selected = true
	itemHeld = newItem
	
	itemHeld.itemID = itemToSpawn
	
	keyDripSlot.texture = null


#TODO: make this work if I feel like it

func _delete_item(itemToDelete):
	itemToDelete.get_parent().remove_child(itemToDelete)
	itemHeld = null
	_clear_grid()


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
		
	PlayerVariables.heldItems.append(itemHeld.itemID)
	
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


func _special_pickup(itemToPickup, equipSlot):
	itemHeld = itemToPickup
	itemHeld.selected = true
	
	#itemHeld.get_parent().remove_child(itemHeld)
	add_child(itemHeld)
	itemHeld.global_position = get_global_mouse_position()
	
	for grid in itemHeld.itemGrids:
		var gridToCheck = itemHeld.gridAnchor.slot_ID + grid[0] + grid[1] * colCount
		gridArray[gridToCheck].state = gridArray[gridToCheck].States.FREE
		gridArray[gridToCheck].itemStored = null
	
	_check_slot_availability(currentSlot)
	_setGrids.call_deferred(currentSlot)
	
	equipSlot.texture = null
	
	match equipSlot:

		leftArmEquipSlot:
			PlayerVariables.leftArmSlot = null
		rightArmEquipSlot:
			PlayerVariables.rightArmSlot = null
		leftLegEquipSlot:
			PlayerVariables.leftLegSlot = null
		rightLegEquipSlot:
			PlayerVariables.rightLegSlot = null

	equipSlot = null

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


func _equip_item(itemToEquip, slotToEquip):
	
	slotToEquip.set_texture(itemToEquip.IconRectPath.get_texture())
	
	match slotToEquip:
		leftArmEquipSlot:
			PlayerVariables.leftArmSlot = itemToEquip
		rightArmEquipSlot:
			PlayerVariables.rightArmSlot = itemToEquip
		leftLegEquipSlot:
			PlayerVariables.leftLegSlot = itemToEquip
		rightLegEquipSlot:
			PlayerVariables.rightLegSlot = itemToEquip	

	itemToEquip.get_parent().remove_child(itemToEquip)
	itemHeld = null
	_clear_grid() # do I even need clear grid?


func _key_unlock(key):
	
	keySlot.texture = load("res://Visual Resources/KeyCard.png")
	
	key.get_parent().remove_child(key)
	itemHeld = null
	_clear_grid()
