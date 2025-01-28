extends Control

@onready var switch = $switch
@onready var switch_on = $SwitchOn
@onready var switch_off = $"SwitchOff"
@onready var skill_name = $"skill name"
var text = "Default"

func _ready() -> void:
	skill_name.text = text 
	if(switch.button_pressed):
		switch_on.visible = true
		switch_off.visible = false
	else:
		switch_on.visible = false
		switch_off.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(switch.button_pressed):
		switch_on.visible = true
		switch_off.visible = false
	else:
		switch_on.visible = false
		switch_off.visible = true
