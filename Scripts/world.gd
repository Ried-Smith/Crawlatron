extends Node3D

const Cell = preload("res://Scenes/testcell.tscn")
const Cell_L = preload("res://Scenes/light_cell.tscn")
const Cell_D = preload("res://Scenes/doorcell.tscn")
const Enemy_Tesla = preload("res://Scenes/TelsaBot.tscn")

var Cells = []
var Types = [0]

@export var Map: PackedScene
@export var Globals: Script

func generate_map():
	if Map is not PackedScene: return
	var map = Map.instantiate()
	var tilemap = map.get_tilemap()
	var used_tiles = tilemap.get_used_cells()
	var default_cell = 0
	var enemy_cell = 1
	var light_cell = 2
	var secret_cell = 3
	var door_cell = 4
	
	var j = 0
	for tile in used_tiles:
		var cell
		match Types[j]:
			enemy_cell:
				cell = Cell.instantiate()
			light_cell:
				cell = Cell_L.instantiate()
			default_cell: 
				cell = Cell.instantiate()
			door_cell: 
				cell = Cell_D.instantiate()
		add_child(cell)
		cell.position=Vector3(tile.x*Globals.GRID_SIZE, 0, tile.y*Globals.GRID_SIZE)
		if Types[j] == enemy_cell:
			var new_enemy = Enemy_Tesla.instantiate()
			add_child(new_enemy)
			new_enemy.position=Vector3(tile.x*Globals.GRID_SIZE, 0,tile.y*Globals.GRID_SIZE)
		Cells.append(cell)
		Types.append(tilemap.get_cell_source_id(tile))
		j+=1
		
	var i = 0
	for cell in Cells:
		cell.update_faces(used_tiles,Types[i])
		i+=1
	map.free()
	

func _ready() -> void:
	generate_map()
