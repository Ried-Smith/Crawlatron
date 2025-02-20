extends RigidBody3D

@export var tbHealth = 100
@export var tbShield = 200

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
var time_left = 0.0
var fight_started  = false
var alive = true
var attacking = false
var test_kill = false

#TODO: Adjust attack name and dmg numbers
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (fight_started): 
		time_left = charge.time_left
		update_bars()


func fight():
	var attack_num = 0
	if(!alive):
		#TODO: Climb tree get player, set up function for fight end
		get_parent().queue_free()
		charge = null
		pass
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
	bot_name = "[center]B00-b Bot[/center]"
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
	charge = Timer.new()
	charge.connect("timeout", _on_timer_timeout)
	add_child(charge)
	charge.wait_time = 4
	charge.one_shot = true
	charge.start()
	battleInterface.enemy_block.attack_name.text = "[center]"+"Mesmer Zap"+"[/center]"
	var dmg = 10
	var type = ELEC
	battleInterface.enemy_block.atb.max_value = charge.wait_time
	time_left = charge.time_left
func attack_2():
	charge = Timer.new()
	charge.connect("timeout", _on_timer_timeout)
	add_child(charge)
	charge.wait_time = 2
	charge.one_shot = true
	charge.start()
	battleInterface.enemy_block.attack_name.text = "[center]"+"Gamma Beam"+"[/center]"
	var dmg = 10
	var type = ELEC
	battleInterface.enemy_block.atb.max_value = charge.wait_time
	time_left = charge.time_left
func attack_3():
	charge = Timer.new()
	charge.connect("timeout", _on_timer_timeout)
	add_child(charge)
	charge.wait_time = 6
	charge.one_shot = true
	charge.start()
	battleInterface.enemy_block.attack_name.text = "[center]"+"Focus Fire Ray"+"[/center]"
	var dmg = 10
	var type = FIRE
	battleInterface.enemy_block.atb.max_value = charge.wait_time
	time_left = charge.time_left
func attack_4():
	test_kill = true
	charge = Timer.new()
	charge.connect("timeout", _on_timer_timeout)
	add_child(charge)
	charge.wait_time = 10
	charge.one_shot = true
	charge.start()
	battleInterface.enemy_block.attack_name.text = "[center]"+"Laser Light Extravaganza"+"[/center]"
	var dmg = 10
	var type = WIERD
	battleInterface.enemy_block.atb.max_value = charge.wait_time
	time_left = charge.time_left

func update_bars():
	battleInterface.enemy_block.health.value = tbHealth
	battleInterface.enemy_block.shield.value = tbShield
	battleInterface.enemy_block.atb.value = time_left
	
	
func _on_timer_timeout():
	if(test_kill):
		alive = false
	fight()
