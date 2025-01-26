extends RigidBody3D

@export var tbHealth = 100
@export var tbShield = 100
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	
	
func fight():
	print("ouch!")
	print(time)

func attack_1():
	pass
func attack_2():
	pass
func attack_3():
	pass
func attack_4():
	pass
