extends Control

@onready var restart = $Button
@onready var world = $".."
@onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(restart.button_pressed):
		world.restart()
		player.playerHealth = player.playerHealthMax
		self.hide()
