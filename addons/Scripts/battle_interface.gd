extends Control

@onready var playerBlock = $HUD/PlayerBlock
@onready var enemy_block = $HUD/enemy_block
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
