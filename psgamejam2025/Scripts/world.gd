extends Node3D

const Cell = preload("res://Scenes/Cell.tscn")

var Cells = []

@export var Map: PackedScene
@export var Globals: Script


func generate_map():
	if Map is not PackedScene: return
	var map = Map.instantiate()
	var tilemap = map.get_tilemap()
	var used_tiles = tilemap.get_used_cells()
	map.free()
	for tile in used_tiles:
		print(tile.get_cell_source_id)
		var cell = Cell.instantiate()
		add_child(cell)
		cell.position=Vector3(tile.x*Globals.GRID_SIZE, 0, tile.y*Globals.GRID_SIZE)
		Cells.append(cell)
	for cell in Cells:
		cell.update_faces(used_tiles)
func _ready() -> void:
	generate_map()
