extends RigidBody3D

@export var tbHealth = 100
@export var tbShield = 100

enum {FIRE,ELEC,PHYS,WIERD}

var battleInterface
var health_bar_max
var health_bar
var shield_bar_max 
var shield_bar
var bot_name
var attack_name = 0
var atb_max 
var atb_val
var charge
var dmg 
var type
var time_left = 0.0
var fight_started  = false
var alive = true
var attacking = false
var test_kill = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (fight_started): 
		time_left = charge.time_left
		update_bars()
	if(tbHealth<=0):
		get_parent().get_parent().player.end_fight()
		get_parent().queue_free()
		charge = null
		
	
func fight():
	var attack_num = 0
	
	match randi()%4:
		0:
			attack_1()
		1:
			attack_2()
		2:
			attack_3()
		3:
			attack_4()
		
		


func fight_ready():
	bot_name = "[center]Tesla Bot[/center]"
	health_bar_max = tbHealth
	health_bar = tbHealth
	shield_bar_max = tbShield
	shield_bar = tbShield
	battleInterface = get_parent().get_parent().battleInterface
	battleInterface.enemy_block.health.max_value = health_bar_max 
	battleInterface.enemy_block.health.value = health_bar 
	battleInterface.enemy_block.shield.max_value = shield_bar_max 
	battleInterface.enemy_block.shield.value = shield_bar 
	battleInterface.enemy_block.bot_name.text = bot_name
	fight_started = true
	fight()




func attack_1():
	test_kill = true
	charge = Timer.new()
	charge.connect("timeout", _on_timer_timeout)
	add_child(charge)
	charge.wait_time = 4
	charge.one_shot = true
	charge.start()
	battleInterface.enemy_block.attack_name.text = "[center]"+"Force Wave"+"[/center]"
	dmg = 10
	type = PHYS
	battleInterface.enemy_block.atb.max_value = charge.wait_time
	#time_left = charge.time_left

func attack_2():
	test_kill = true
	charge = Timer.new()
	charge.connect("timeout", _on_timer_timeout)
	add_child(charge)
	charge.wait_time = 2
	charge.one_shot = true
	charge.start()
	battleInterface.enemy_block.attack_name.text = "[center]"+"Ray Gun"+"[/center]"
	dmg = 10
	type = ELEC
	battleInterface.enemy_block.atb.max_value = charge.wait_time
	#time_left = charge.time_left
func attack_3():
	test_kill = true
	charge = Timer.new()
	charge.connect("timeout", _on_timer_timeout)
	add_child(charge)
	charge.wait_time = 6
	charge.one_shot = true
	charge.start()
	battleInterface.enemy_block.attack_name.text = "[center]"+"Super Telsa Power"+"[/center]"
	dmg = 35
	type = ELEC
	battleInterface.enemy_block.atb.max_value = charge.wait_time
	#time_left = charge.time_left
func attack_4():
	test_kill = true
	charge = Timer.new()
	charge.connect("timeout", _on_timer_timeout)
	add_child(charge)
	charge.wait_time = 10
	charge.one_shot = true
	charge.start()
	battleInterface.enemy_block.attack_name.text = "[center]"+"Triple Shocker Surprise"+"[/center]"
	dmg = 50
	type = ELEC
	battleInterface.enemy_block.atb.max_value = charge.wait_time
	#time_left = charge.time_left

func update_bars():
	battleInterface.enemy_block.health.value = tbHealth
	battleInterface.enemy_block.shield.value = tbShield
	battleInterface.enemy_block.atb.value = time_left

func _on_timer_timeout():
	fight()
