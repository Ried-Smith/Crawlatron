extends CSGMesh3D

@onready var openDoor = $"../openDoor"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func open_door():
	openDoor.play()
	self.use_collision = 0
	self.hide()
