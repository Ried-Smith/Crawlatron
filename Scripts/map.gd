extends Node2D

@onready var tileMap = $TileMapLayer
@onready var viewport = $SubViewport
@onready var minimapTextureRect = $SubViewport/TextureRect

func _ready():
	viewport.size = tileMap.get_used_rect().size * tileMap.cell_size
	
	var minimapTexture = ImageTexture.new()
	minimapTexture.create(viewport.size.x, viewport.size.y, Image.FORMAT_RGBA8)
	
	viewport.render_target_update_mode = Viewport.VRS_UPDATE_ALWAYS
	viewport.render_target_vflip = true
	viewport.set_size(viewport.size)
	
	minimapTextureRect.texture = minimapTexture
	
	_update_minimap_texture(minimapTexture)
	
func _update_minimap_texture(texture: ImageTexture):
	var img = viewport.get_texture().get_data()
	img.lock()
	
	var scaledImg = img.scale(0.1,0.1) #scaled down by 10%
	
	texture.set_data(scaledImg)
	img.unlock()
	
func get_tilemap():
	return $TileMapLayer
