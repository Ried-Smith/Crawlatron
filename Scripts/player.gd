extends Node3D

@onready var front_ray := $RayForward
@onready var back_ray := $RayBack
@onready var right_ray := $RayRight
@onready var left_ray := $RayLeft
@onready var headbob :=$AnimationPlayer
@onready var MechStep := $MechStep
@onready var MechTurn := $MechTurn

@onready var inventoryMenu = $"../Inventory"
@onready var battleInterface = $"../BattleInterface"




const MOVE_SPEED = 0.3


@export var headbob_on = false
@export var move_juice  = false
@export var Globals: Script

var playerHealth = 100
var playerHealthMax = 100
var playerShield = 100
var playerShieldMax = 100

#TODO: dont let the number of skills equipped from items exceed 6

#TODO: dont let the number of weapons equipped from items exceed 4

#TODO: put the inventory equipment here
#TODO: when changing inv call update func
var equip = []

enum {FIRE,ELEC,PHYS,WIERD}
var weap1
var weap2
var weap3
var weap4
var weapons  = [weap1,weap2,weap3,weap4]

var skill1
var skill2
var skill3
var skill4
var skill5
var skill6
var skills = [skill1,skill2,skill3,skill4,skill5,skill6]

var tween

var fighting = false
func _physics_process(delta: float) -> void:
	updateDMG()
	if tween is Tween:
		if tween.is_running():
			return
	if Input.is_key_label_pressed(KEY_W) and not front_ray.is_colliding() and not fighting: 
		if(move_juice):
			tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			MechStep.play()
		else:
			tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.FORWARD * 2), MOVE_SPEED)
		if(headbob_on):
			headbob.play("headbob")
		
	if Input.is_key_label_pressed(KEY_S) and not back_ray.is_colliding() and not fighting:
		if(move_juice):
			tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			MechStep.play()
		else:
			tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.BACK * 2), MOVE_SPEED)
		if(headbob_on):
			headbob.play("headbob")
		
	if Input.is_key_label_pressed(KEY_A) and not left_ray.is_colliding() and not fighting:
		if(move_juice):
			tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			MechStep.play()
		else:
			tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.LEFT * 2), MOVE_SPEED)
		if(headbob_on):
			headbob.play("headbob")
		
	if Input.is_key_label_pressed(KEY_D) and not right_ray.is_colliding() and not fighting:
		if(move_juice):
			tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			MechStep.play()
			
		else:
			tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.RIGHT * 2), MOVE_SPEED)
		if(headbob_on):
			headbob.play("headbob")

	if Input.is_key_label_pressed(KEY_Q) and not fighting:
		if(move_juice):
			tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			MechTurn.play()
		else:
			tween = create_tween()
		tween.tween_property(self, "transform", transform.rotated_local(Vector3.UP, PI/2), MOVE_SPEED)
		
	if Input.is_key_label_pressed(KEY_E) and not fighting:
		if(move_juice):
			tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			MechTurn.play()
		else:
			tween = create_tween()
		tween.tween_property(self, "transform", transform.rotated_local(Vector3.UP, -PI/2), MOVE_SPEED)

	if Input.is_action_just_pressed("Inventory"):
		if !inventoryMenu.is_visible():
			inventoryMenu.show()

		else:
			inventoryMenu.hide()

	if Input.is_action_just_pressed("Attack") and front_ray.is_colliding():
		var thing_hit = front_ray.get_collider()
		if "collision_layer" not in thing_hit:
			print("wall")
		else:
			hit(thing_hit)
	
	if Input.is_action_just_pressed("testinput"):
		pass
		inventoryMenu._key_check()

func hit(hit_object):
	match hit_object.collision_layer:
		1: #walls
			pass
		2: #doors
			#TODO: open door function should check if player has 'key' in inventory, if not, fuck you
			if inventoryMenu._key_check() == true:
				hit_object.open_door()
			#else:
				#print("no key detected")
		4: #enemy
			if !battleInterface.is_visible():
				battleInterface.show()
				fighting  = true
				hit_object.fight_ready()
				setWeapons()
				setSkills()
				setStats()
			else:
				battleInterface.hide()
				fighting  = false
		8: #interactive switch or pickup
			pass

func setWeapons():
	for item in equip:
		if item.is_weapon == true:
			for i in weapons:
				if i.taken != false:
					weapons[i] = item

func setSkills():
	for item in equip:
		if item.has_skill == true:
			for i in skills:
				if i.taken != false:
					weapons[i] = item
func setStats():
	battleInterface.playerBlock.healthBar.max_value = playerHealthMax
	battleInterface.playerBlock.shieldBar.max_value = playerShieldMax
func updateDMG():
	battleInterface.playerBlock.healthBar.value = playerHealth
	battleInterface.playerBlock.shieldBar.value = playerShield


func defaultSkillsAndWeaps():
	weap1.name = "Name 1"
	weap2.name = "Name 2"
	weap3.name = "Name 3"
	weap4.name = "Name 4"
	
	weap1.type = PHYS 
	weap2.type = ELEC
	weap3.type = FIRE 
	weap4.type = PHYS
	
	weap1.dmg_min = 5
	weap2.dmg_min = 5
	weap3.dmg_min = 5
	weap4.dmg_min = 5
	
	weap1.dmg_max = 15
	weap2.dmg_max = 15
	weap3.dmg_max = 15
	weap4.dmg_max = 15
	
	weap1.charge_time = 2
	weap1.charge_time = 4
	weap1.charge_time = 6
	weap1.charge_time = 8

func end_fight():
	if battleInterface.is_visible():
		battleInterface.hide()
		fighting  = false
