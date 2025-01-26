extends Node3D

#TODO: fuck all this declare an instance of inventory or some shit idk that might work and just call the functions here



@onready var Inventory = preload("res://Scenes/inventory.tscn")
@onready var front_ray := $RayForward
@onready var back_ray := $RayBack
@onready var right_ray := $RayRight
@onready var left_ray := $RayLeft
@onready var headbob :=$AnimationPlayer
@onready var MechStep := $MechStep
@onready var MechTurn := $MechTurn

@onready var inventoryMenu = $"../Inventory"

var itemData = {}

const MOVE_SPEED = 0.3

var tween
@export var headbob_on = false
@export var move_juice  = false

func _ready():
	Inventory.instantiate()
	

func _physics_process(delta: float) -> void:
	#This is a dog ass way to code this but oh well at least its not all one chain
	if tween is Tween:
		if tween.is_running():
			return
	if Input.is_key_label_pressed(KEY_W) and not front_ray.is_colliding(): 
		if(move_juice):
			tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			MechStep.play()
		else:
			tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.FORWARD * 2), MOVE_SPEED)
		if(headbob_on):
			headbob.play("headbob")
		
	if Input.is_key_label_pressed(KEY_S) and not back_ray.is_colliding():
		if(move_juice):
			tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			MechStep.play()
		else:
			tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.BACK * 2), MOVE_SPEED)
		if(headbob_on):
			headbob.play("headbob")
		
	if Input.is_key_label_pressed(KEY_A) and not left_ray.is_colliding():
		if(move_juice):
			tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			MechStep.play()
		else:
			tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.LEFT * 2), MOVE_SPEED)
		if(headbob_on):
			headbob.play("headbob")
		
	if Input.is_key_label_pressed(KEY_D) and not right_ray.is_colliding():
		if(move_juice):
			tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			MechStep.play()
			
		else:
			tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.RIGHT * 2), MOVE_SPEED)
		if(headbob_on):
			headbob.play("headbob")

	if Input.is_key_label_pressed(KEY_Q):
		if(move_juice):
			tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			MechTurn.play()
		else:
			tween = create_tween()
		tween.tween_property(self, "transform", transform.rotated_local(Vector3.UP, PI/2), MOVE_SPEED)
		
	if Input.is_key_label_pressed(KEY_E):
		if(move_juice):
			tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			MechTurn.play()
		else:
			tween = create_tween()
		tween.tween_property(self, "transform", transform.rotated_local(Vector3.UP, -PI/2), MOVE_SPEED)
	
	if Input.is_action_just_pressed("Inventory"):
		if !inventoryMenu.is_visible():
			inventoryMenu.show()
			inventoryMenu.set_process(true)
			
		else:
			inventoryMenu.hide()
			inventoryMenu.set_process(false)
	
	
	if Input.is_action_just_pressed("Attack") and front_ray.is_colliding():
		var thing_hit = front_ray.get_collider()
		print(thing_hit)
		



# this is just a test function rn
# but this will run whenever equipped items are needed. maybe just run it whenever a change is made? we can test it out
# maybe run on inventory opening and closing?

func _load_json_file(filepath : String):
	if FileAccess.file_exists(filepath):
		var dataFile = FileAccess.open(filepath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("error reading file")
			
	else:
		print("File does not exist")
