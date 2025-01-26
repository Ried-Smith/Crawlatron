extends Button

@onready var switch_on = $"../SwitchOn"
@onready var switch_off = $"../SwitchOff"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(button_pressed):
		switch_on.visible = true
		switch_off.visible = false
	else:
		switch_on.visible = false
		switch_off.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(button_pressed):
		switch_on.visible = true
		switch_off.visible = false
	else:
		switch_on.visible = false
		switch_off.visible = true
	
