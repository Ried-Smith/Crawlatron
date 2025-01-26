extends TextureRect
@onready var mapPath = preload("res://Scenes/map.tscn")
@onready var testmap = "res://Visual Resources/evangelion-ha-cambiado-version-netflix-1024x548-4204003973.jpg"
@onready var mapTest = TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	#TextureRect.texture = mapTest.get_navigation_map()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# track where the player is here
	pass
