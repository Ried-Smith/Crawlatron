extends Control

#TODO: use new sprites for items, add stats and text to them and shit 
#TODO: add bonus slots on bottom

@onready var slotScene = preload("res://Scenes/slot.tscn")
@onready var gridContainer = $ItemInventory/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var itemScene = preload("res://Scenes/item.tscn")
@onready var scrollContainer = $ItemInventory/MarginContainer/VBoxContainer/ScrollContainer
@onready var colCount = $ItemInventory/MarginContainer/VBoxContainer/ScrollContainer/GridContainer.columns
@onready var inventoryMenu = $"."

@onready var playerScene = preload("res://Scenes/player.tscn").instantiate()



#TODO: there has to be a more efficent way to declare these variabnles
# I REALLY dont wanna do one for each slot but if I must....
# well I could just pass each slot in the method

@onready var helmEquipSlot = $ColorRect/Head/HeadSprite
@onready var leftArmEquipSlot = $ColorRect/LeftArm/LeftArmSprite
@onready var rightArmEquipSlot = $ColorRect/RightArm/RightArmSprite
@onready var chestEquipSlot = $ColorRect/Chest/ChestSprite
@onready var leftLegEquipSlot = $ColorRect/LeftLeg/LeftLegSprite
@onready var rightLegEquipSlot = $ColorRect/RightLeg/RightLegSprite

var gridArray = []
var itemHeld = null
var currentSlot = null
var canPlace = false
var iconAnchor : Vector2

func _ready():
	for i in range(32):
		createSlot()
		
	inventoryMenu.hide()
	
func _process(delta):
	
	# did this make it crash lmao?
		if itemHeld:
		#TODO: but might wanna add it to here -- if scrollContainer.get_global_rect().hasPoint(get_global_mouse_position()):	
			if Input.is_action_just_pressed("rotateItem"):
				_rotate_item()
			
			#TODO: maybe if have time, be able to swap things around
			#TODO: maybe add a nice sound and a message later 
			
			# God this is so fucking ass but it works its fine now
			if Input.is_action_just_pressed("placeItem"):
				if scrollContainer.get_global_rect().has_point(get_global_mouse_position()):
					_place_item()
					
				elif helmEquipSlot.get_global_rect().has_point(get_global_mouse_position()):
					if helmEquipSlot.texture == null:
						_equip_item(itemHeld, helmEquipSlot)
					else:
						print("item already equipped!!")

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
						
				elif chestEquipSlot.get_global_rect().has_point(get_global_mouse_position()):
					if chestEquipSlot.texture == null:
						_equip_item(itemHeld, chestEquipSlot)
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
						


		else:
			if Input.is_action_just_pressed("placeItem"):
				if scrollContainer.get_global_rect().has_point(get_global_mouse_position()):
					_pickup_item()
					
				elif helmEquipSlot.get_global_rect().has_point(get_global_mouse_position()):
					if !helmEquipSlot.texture == null:
						_special_pickup(PlayerVariables.helmetSlot, helmEquipSlot)
						
				elif leftArmEquipSlot.get_global_rect().has_point(get_global_mouse_position()):
					if !leftArmEquipSlot.texture == null:
						_special_pickup(PlayerVariables.leftArmSlot,leftArmEquipSlot)
						
				elif rightArmEquipSlot.get_global_rect().has_point(get_global_mouse_position()):
					if !rightArmEquipSlot.texture == null:
						_special_pickup(PlayerVariables.rightArmSlot, rightArmEquipSlot)
						
				elif chestEquipSlot.get_global_rect().has_point(get_global_mouse_position()):
					if !chestEquipSlot.texture == null:
						_special_pickup(PlayerVariables.chestSlot, chestEquipSlot)
						
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


func _on_button_spawn_pressed():
	var newItem = itemScene.instantiate()
	add_child(newItem)
	newItem._loadItem(1)
	newItem.selected = true
	itemHeld = newItem


#TODO: make this work if I feel like it
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
		helmEquipSlot:
			PlayerVariables.helmetSlot = null
		leftArmEquipSlot:
			PlayerVariables.leftArmSlot = null
		rightArmEquipSlot:
			PlayerVariables.rightArmSlot = null
		chestEquipSlot:
			PlayerVariables.chestSlot = null
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
		helmEquipSlot:
			PlayerVariables.helmetSlot = itemToEquip
		leftArmEquipSlot:
			PlayerVariables.leftArmSlot = itemToEquip
		rightArmEquipSlot:
			PlayerVariables.rightArmSlot = itemToEquip
		chestEquipSlot:
			PlayerVariables.chestSlot = itemToEquip
		leftLegEquipSlot:
			PlayerVariables.leftLegSlot = itemToEquip
		rightLegEquipSlot:
			PlayerVariables.rightLegSlot = itemToEquip	

	itemToEquip.get_parent().remove_child(itemToEquip)
	itemHeld = null
	_clear_grid() # do I even need clear grid?
