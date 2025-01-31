extends Node

enum {FIRE,ELEC,PHYS,WIERD}

func get_item(item_id) -> weapon:
	var weap = weapon.new()
	match(item_id):
		-1:
			weap.w_name = "NONE"
			weap.type = PHYS
			weap.dmg_min = 0
			weap.dmg_max = 0
			weap.charge_time = 0
		1:
			weap.w_name = "Crab Claw"
			weap.type = PHYS
			weap.dmg_min = 5
			weap.dmg_max = 15
			weap.charge_time = 3
		2:
			weap.w_name = "Tesla Coil"
			weap.type = ELEC
			weap.dmg_min = 10
			weap.dmg_max = 20
			weap.charge_time = 8
		3:
			weap.w_name = "Power Piston"
			weap.type = PHYS
			weap.dmg_min = 10
			weap.dmg_max = 25
			weap.charge_time = 6
		4:
			weap.w_name = "Extendo-Cordo"
			weap.type = ELEC
			weap.dmg_min = 10
			weap.dmg_max = 30
			weap.charge_time = 10
		5:
			weap.w_name = "Fire Core"
			weap.type = FIRE
			weap.dmg_min = 10
			weap.dmg_max = 45
			weap.charge_time = 8
		6:
			weap.w_name = "Gamma Core"
			weap.type = PHYS
			weap.dmg_min = 10
			weap.dmg_max = 45
			weap.charge_time = 8
		7:
			weap.w_name = "Plasma Core"
			weap.type = ELEC
			weap.dmg_min = 15
			weap.dmg_max = 45
			weap.charge_time = 8
	return weap
