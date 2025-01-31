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
@onready var itemInventory = $"../Inventory/ItemInventory"
@onready var equipMenu = $"../Inventory/ColorRect"
@onready var dropSlot = $"../Inventory/ItemDrop"
@onready var keyCheck = $"../Inventory/KeyCheck"
@onready var keySlot = $"../Inventory/KeyCheck/TextureRect/TextureRect"
@onready var battleInterface = $"../BattleInterface"
@onready var gameOver = $"../gameOverScreen"
@onready var pilot = $pilot
@onready var weapon_man = $weapon_manager
@onready var victory = $"../victory"



const MOVE_SPEED = 0.3


@export var headbob_on = false
@export var move_juice  = false
@export var Globals: Script

var playerHealth = 100
var playerHealthMax = 100
var playerShield = 100
var playerShieldMax = 100

@onready var leftArm = inventoryMenu.leftArmEquipSlot
@onready var rightArm = inventoryMenu.rightArmEquipSlot
@onready var leftLeg = inventoryMenu.leftLegEquipSlot
@onready var rightLeg = inventoryMenu.rightLegEquipSlot
enum {FIRE,ELEC,PHYS,WIERD}

var weap1 = weapon.new() 
var weap2 = weapon.new()
var weap3 = weapon.new()
var weap4 = weapon.new()


var weapons  = [weap1,weap2,weap3,weap4]
var default_weapon = weapon.new()


var tween
var current_enemy
var fighting = false
var dead = false
var restart_debug =true

var charge1 
var charge2
var charge3
var charge4
var time_left1 = 0
var time_left2 = 0
var time_left3 = 0
var time_left4 = 0

func _ready() -> void:
	default_weapon.w_name = "Big weak punch"
	default_weapon.charge_time = 2
	default_weapon.dmg_max = 40
	default_weapon.dmg_min = 1
	default_weapon.type = PHYS
	


func _process(delta: float) -> void:
	if(fighting and !dead):
		time_left1 = charge1.time_left
		if(weap2.w_name != "NONE"):
			time_left2 = charge2.time_left
		if(weap3.w_name != "NONE"):
			time_left3 = charge3.time_left
		if(weap4.w_name != "NONE"):
			time_left4 = charge4.time_left
	update_bars()
	if(playerHealth<=0): 
		dead = true


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

	if Input.is_action_just_pressed("Inventory"):
		if !inventoryMenu.is_visible():
			inventoryMenu.show()
			equipMenu.show()
			itemInventory.show()
			dropSlot.hide()
			keyCheck.hide()
			
		else:
			inventoryMenu.hide()
			
	if Input.is_action_just_pressed("Attack") and front_ray.is_colliding():
		var thing_hit = front_ray.get_collider()
		if "collision_layer" not in thing_hit:
			print("wall")
		else:
			hit(thing_hit)

			
	if Input.is_action_just_pressed("testinput"):
		inventoryMenu._on_death()
		


func hit(hit_object):
	match hit_object.collision_layer:
		1: #walls
			pass
		2: #doors
			inventoryMenu.show()
			equipMenu.hide()
			itemInventory.show()
			dropSlot.hide()
			keyCheck.show()
			
			if keySlot.texture == load("res://Visual Resources/KeyCard.png"):
				hit_object.open_door() 
				
				keySlot.texture == null
				keyCheck.hide()
				itemInventory.hide()
				
		4: #enemy
			if !battleInterface.is_visible():
				battleInterface.show()
				fighting  = true
				current_enemy = hit_object
				hit_object.fight_ready()
				setWeapons()
				setStats()
				attack1()
				attack2()
				attack3()
				attack4()
		8: #interactive switch or pickup
			hit_object.eat_totem()
		16:
			if (get_parent().Enemies.size()) <= 0:
				get_parent().next_level()
			else:
				pilot.show()
				cant_leave1.play()
				cant_leave1.connect("finished",_hide_pilot)
				

func setWeapons():
	if(PlayerVariables.leftArmSlot == null): 
		weap1.w_name = default_weapon.w_name
		weap1.dmg_max = default_weapon.dmg_max
		weap1.dmg_min = default_weapon.dmg_min
		weap1.type = default_weapon.type
		weap1.charge_time = default_weapon.charge_time
	else:
		weap1 = weapon_man.get_item(PlayerVariables.leftArmSlot.itemID)
	if(PlayerVariables.rightArmSlot != null):
		weap2 = weapon_man.get_item(PlayerVariables.rightArmSlot.itemID)
	else:
		weap2 = weapon_man.get_item(-1)
	if(PlayerVariables.leftLegSlot != null):
		weap3 = weapon_man.get_item(PlayerVariables.leftLegSlot.itemID)
	else:
		weap3 = weapon_man.get_item(-1)
	if(PlayerVariables.rightLegSlot != null):
		weap4 = weapon_man.get_item(PlayerVariables.rightLegSlot.itemID)
	else:
		weap4= weapon_man.get_item(-1)


func setStats():
	battleInterface.playerBlock.healthBar.max_value = playerHealthMax
	battleInterface.playerBlock.shieldBar.max_value = playerShieldMax
	
func update_bars():
	battleInterface.playerBlock.healthBar.value = playerHealth
	battleInterface.playerBlock.shieldBar.value = playerShield
	battleInterface.ATB1.atb.value = time_left1
	battleInterface.ATB2.atb.value = time_left2
	battleInterface.ATB3.atb.value = time_left3
	battleInterface.ATB4.atb.value = time_left4
	
func defaultSkillsAndWeaps():
	weap1.w_name = "Empty"
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
	weap2.charge_time = 4
	weap3.charge_time = 6
	weap4.charge_time = 8

func end_fight(botType):
	match botType:
		# 1=crab, 2=tesla, 3=bot with big mommy milkers AWOOGA
		1:
			inventoryMenu._on_death(1)
		2:
			inventoryMenu._on_death(2)
		3:
			inventoryMenu._on_death(3)
			
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
	playerShield = playerShieldMax

func attack1():
	battleInterface.ATB1.weapon_name.text = "[center]"+weap1.w_name+"[/center]"
	charge1 = Timer.new()
	add_child(charge1)
	charge1.wait_time = weap1.charge_time
	battleInterface.ATB1.atb.max_value = charge1.wait_time
	charge1.connect("timeout",_weap1_timeout)
	charge1.one_shot = true
	charge1.start()

func attack2():
	battleInterface.ATB2.weapon_name.text = "[center]"+weap2.w_name+"[/center]"
	if(weap2.w_name != "NONE"):
		pass
	else:
		return
	charge2 = Timer.new()
	add_child(charge2)
	charge2.wait_time = weap2.charge_time
	battleInterface.ATB2.atb.max_value = charge2.wait_time
	charge2.connect("timeout",_weap2_timeout)
	charge2.one_shot = true
	charge2.start()

func attack3():
	battleInterface.ATB3.weapon_name.text = "[center]"+weap3.w_name+"[/center]"
	if(weap3.w_name != "NONE"):
		pass
	else:
		return
	charge3 = Timer.new()
	add_child(charge3)
	charge3.wait_time = weap3.charge_time
	battleInterface.ATB3.atb.max_value = charge3.wait_time
	charge3.connect("timeout",_weap3_timeout)
	charge3.one_shot = true
	charge3.start()
func attack4():
	battleInterface.ATB4.weapon_name.text = "[center]"+weap4.w_name+"[/center]"
	if(weap4.w_name != "NONE"):
		pass
	else:
		return
	charge4 = Timer.new()
	add_child(charge4)
	charge4.wait_time = weap4.charge_time
	battleInterface.ATB4.atb.max_value = charge4.wait_time
	charge4.connect("timeout",_weap4_timeout)
	charge4.one_shot = true
	charge4.start()
	
func _hide_pilot():
	if pilot.is_visible():
		pilot.hide()

func _weap1_timeout():
	if(fighting and !dead):
		remove_child(charge1)
		dmg_mod(weap1.type,randi()%weap1.dmg_max+weap1.dmg_min+1)
		attack1()
func _weap2_timeout():
	if(fighting and !dead):
		remove_child(charge2)
		dmg_mod(weap2.type,randi()%weap2.dmg_max+weap2.dmg_min+1)
		attack2()
func _weap3_timeout():
	if(fighting and !dead):
		remove_child(charge3)
		dmg_mod(weap3.type,randi()%weap3.dmg_max+weap3.dmg_min+1)
		attack3()
func _weap4_timeout():
	if(fighting and !dead):
		remove_child(charge4)
		dmg_mod(weap4.type,randi()%weap4.dmg_max+weap4.dmg_min+1)
		attack4()

func dmg_mod(TYPE,dmg):
	var dmg_shield
	var dmg_health
	var enemy_shield = current_enemy.tbShield
	var enemy_health = current_enemy.tbHealth
	
	match TYPE:
		FIRE:
			dmg_shield = round(dmg * .25)
			dmg_health = round(dmg * .75)
		ELEC:
			dmg_shield = round(dmg * .75)
			dmg_health = round(dmg * .25)
		PHYS:
			dmg_shield = dmg
			dmg_health = 0
		WIERD:
			dmg_shield = round(dmg * .50)
			dmg_health = round(dmg * .50)
	
	if(enemy_shield<=dmg_shield):
		dmg_shield-=enemy_shield
		dmg_health+=dmg_shield
		dmg_shield = 0
		enemy_shield = 0
	enemy_shield -= dmg_shield
	enemy_health -= dmg_health
	current_enemy.tbHealth = enemy_health
	current_enemy.tbShield = enemy_shield

func death():
	if(true):
		gameOver.show()
		battleInterface.hide()

func battleReset():
	if battleInterface.is_visible():
		battleInterface.hide()
	fighting  = false
	dead = false
	playerShield = playerShieldMax
	playerHealth = playerHealthMax
	if(charge1!=null):remove_child(charge1)
	if(charge2!=null):remove_child(charge2)
	if(charge3!=null):remove_child(charge3)
	if(charge4!=null):remove_child(charge4)
	update_bars()
	
func win():
	inventoryMenu.hide()
	battleInterface.hide()
	gameOver.hide()
	victory.show()
