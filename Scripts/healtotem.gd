extends CSGMesh3D

@onready var anim = $AnimationPlayer
@onready var sound = $AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	anim.play("cubefloat")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func eat_totem():
	sound.play()
	get_parent().get_parent().player.playerHealthMax += 10
	get_parent().get_parent().player.playerHealth = get_parent().get_parent().player.playerHealthMax
	self.use_collision = 0
	self.hide()
