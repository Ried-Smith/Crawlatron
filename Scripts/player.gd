extends Node3D

@onready var front_ray := $RayForward
@onready var back_ray := $RayBack
@onready var right_ray := $RayRight
@onready var left_ray := $RayLeft
@onready var headbob :=$AnimationPlayer
@onready var MechStep := $MechStep
@onready var MechTurn := $MechTurn
@onready var cant_leave1 := $"Cant leave"
@onready var botkill1 = $botkill1
@onready var botkill2 = $botkill2
@onready var botkill3 = $botkill3
@onready var inventoryMenu = $"../Inventory"
@onready var battleInterface = $"../BattleInterface"
@onready var pilot = $pilot




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

var weap1 = weapon.new()
var weap2 = weapon.new()
var weap3 = weapon.new()
var weap4 = weapon.new()
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

var charge1 
var charge2
var charge3
var charge4
var time_left1
var time_left2
var time_left3
var time_left4

func _ready() -> void:
	defaultSkillsAndWeaps()

func _process(delta: float) -> void:
	updateDMG()


func _physics_process(delta: float) -> void:
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

	#TODO:GET RID OF THIS BEFORE RELEASE PLEASE IM BEGGING YOU PLEASE PLEASE
	#TODO:GET RID OF THIS BEFORE RELEASE PLEASE IM BEGGING YOU PLEASE PLEASE
	#TODO:GET RID OF THIS BEFORE RELEASE PLEASE IM BEGGING YOU PLEASE PLEASE
	#TODO:GET RID OF THIS BEFORE RELEASE PLEASE IM BEGGING YOU PLEASE PLEASE
	#TODO:GET RID OF THIS BEFORE RELEASE PLEASE IM BEGGING YOU PLEASE PLEASE
	#TODO:GET RID OF THIS BEFORE RELEASE PLEASE IM BEGGING YOU PLEASE PLEASE
	#TODO:GET RID OF THIS BEFORE RELEASE PLEASE IM BEGGING YOU PLEASE PLEASE
	#TODO:GET RID OF THIS BEFORE RELEASE PLEASE IM BEGGING YOU PLEASE PLEASE
	#TODO:GET RID OF THIS BEFORE RELEASE PLEASE IM BEGGING YOU PLEASE PLEASE
	#TODO:GET RID OF THIS BEFORE RELEASE PLEASE IM BEGGING YOU PLEASE PLEASE
	#TODO:GET RID OF THIS BEFORE RELEASE PLEASE IM BEGGING YOU PLEASE PLEASE
	if Input.is_key_label_pressed(KEY_K) and not fighting:
		get_parent().clear_enemies()


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
				attack()
		8: #interactive switch or pickup
			pass
		16:
			if (get_parent().Enemies.size()) <= 0:
				get_parent().clear_map()
			else:
				pilot.show()
				cant_leave1.play()
				cant_leave1.connect("finished",_hide_pilot)
				

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
	weap1.w_name = "Name 1"
	weap2.w_name = "Name 2"
	weap3.w_name = "Name 3"
	weap4.w_name = "Name 4"
	
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
	match randi()%3:
		0:
			botkill1.play()
		1:
			botkill2.play()
		2: 
			botkill3.play()
	if battleInterface.is_visible():
		battleInterface.hide()
		fighting  = false

func attack():
	var charge1 = Timer.new()
	var charge2 = Timer.new()
	var charge3 = Timer.new()
	var charge4 = Timer.new()
	
	charge1.wait_time = weap1.charge_time
	charge2.wait_time = weap2.charge_time
	charge3.wait_time = weap3.charge_time
	charge4.wait_time = weap4.charge_time
	
	battleInterface.ATB1.weapon_name.text = "[center]"+weap1.w_name+"[/center]"
	battleInterface.ATB2.weapon_name.text = "[center]"+weap2.w_name+"[/center]"
	battleInterface.ATB3.weapon_name.text = "[center]"+weap3.w_name+"[/center]"
	battleInterface.ATB4.weapon_name.text = "[center]"+weap4.w_name+"[/center]"

func _hide_pilot():
	if pilot.is_visible():
		pilot.hide()
