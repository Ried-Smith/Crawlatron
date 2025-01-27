extends TextureRect

signal slot_entered(slot)
signal slot_exited(slot)

@onready var filter = $"Status Filter"

var slot_ID
var isHovering = false
enum States {DEFAULT, TAKEN, FREE}
var state = States.DEFAULT
var itemStored = null

func ready():
	pass

func _set_color(a_state = States.DEFAULT) -> void:
	match a_state:
		States.DEFAULT:
			filter.color = Color(Color.WHITE, 0.2)
		States.TAKEN:
			filter.color = Color(Color.RED, 0.2)
		States.FREE:
			filter.color = Color(Color.GREEN, 0.2)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_global_rect().has_point(get_global_mouse_position()):
		if not isHovering:
			isHovering = true
			emit_signal("slot_entered",self)
	else:
		if isHovering:
			isHovering = false
			emit_signal("slot_exited", self)
