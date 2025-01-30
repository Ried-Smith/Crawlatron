extends Node3D

const Cell = preload("res://Scenes/testcell.tscn")
const Cell_L = preload("res://Scenes/light_cell.tscn")
const Cell_D = preload("res://Scenes/doorcell.tscn")
const Cell_E = preload("res://Scenes/exit_cell.tscn")
const Enemy_Tesla = preload("res://Scenes/TelsaBot.tscn")
const Enemy_Boob = preload("res://Scenes/booby_bot.tscn")
const Enemy_Handsy = preload("res://Scenes/HandyBot.tscn")
const door_block = preload("res://Scenes/doorblock.tscn")
const map1 = preload("res://Scenes/map.tscn")
const map2 = preload("res://Scenes/map_2.tscn")

var Cells = []
var Types = [0]
var Enemies = []

@export var Map: PackedScene
@export var Globals: Script
@onready var battleInterface = $BattleInterface
@onready var player = $Player

func generate_map(map_name):
	if Map is not PackedScene: return
	var map = map_name.instantiate()
	var tilemap = map.get_tilemap()
	var used_tiles = tilemap.get_used_cells()
	var default_cell = 0
	var enemy_cell = 1
	var light_cell = 2
	var secret_cell = 3
	var door_cell = 4
	var enemy_handsy = 5
	var enemy_booby = 6
	var start = 7
	var exit = 8
	
	var j = 0
	for tile in used_tiles:
		var cell
		match tilemap.get_cell_source_id(tile):
			enemy_cell:
				cell = Cell.instantiate()
				cell.position=Vector3(tile.x*Globals.GRID_SIZE, 0, tile.y*Globals.GRID_SIZE)
				var new_enemy = Enemy_Tesla.instantiate()
				add_child(new_enemy)
				Enemies.append(new_enemy)
				new_enemy.position=Vector3(tile.x*Globals.GRID_SIZE, 0,tile.y*Globals.GRID_SIZE)
			light_cell:
				cell = Cell_L.instantiate()
				cell.position=Vector3(tile.x*Globals.GRID_SIZE, 0, tile.y*Globals.GRID_SIZE)
			default_cell: 
				cell = Cell.instantiate()
				cell.position=Vector3(tile.x*Globals.GRID_SIZE, 0, tile.y*Globals.GRID_SIZE)
			door_cell: 
				cell = Cell_D.instantiate()
				cell.position=Vector3(tile.x*Globals.GRID_SIZE, 0, tile.y*Globals.GRID_SIZE)
			enemy_handsy:
				cell = Cell.instantiate()
				cell.position=Vector3(tile.x*Globals.GRID_SIZE, 0, tile.y*Globals.GRID_SIZE)
				var new_enemy = Enemy_Handsy.instantiate()
				add_child(new_enemy)
				Enemies.append(new_enemy)
				new_enemy.position=Vector3(tile.x*Globals.GRID_SIZE, 0,tile.y*Globals.GRID_SIZE)
			enemy_booby:
				cell = Cell.instantiate()
				cell.position=Vector3(tile.x*Globals.GRID_SIZE, 0, tile.y*Globals.GRID_SIZE)
				var new_enemy = Enemy_Boob.instantiate()
				add_child(new_enemy)
				Enemies.append(new_enemy)
				new_enemy.position=Vector3(tile.x*Globals.GRID_SIZE, 0,tile.y*Globals.GRID_SIZE)
			start: 
				cell = Cell.instantiate()
				cell.position=Vector3(tile.x*Globals.GRID_SIZE, 0, tile.y*Globals.GRID_SIZE)
				player.position = Vector3(tile.x*Globals.GRID_SIZE, 0,tile.y*Globals.GRID_SIZE)
			exit:
				cell = Cell_E.instantiate()
				cell.position=Vector3(tile.x*Globals.GRID_SIZE,0,tile.y*Globals.GRID_SIZE)
		add_child(cell)
		Cells.append(cell)
		Types.append(tilemap.get_cell_source_id(tile))
		j+=1
	var i = 0
	for cell in Cells:
		cell.update_faces(used_tiles,Types[i])
		i+=1
	map.free()
	
func clear_map():
	for cell in Cells:
		remove_child(cell)
	generate_map(map2)
	
func clear_enemies():
	for enemy in Enemies:
		remove_child(enemy)
	Enemies = []
func _ready() -> void:
	generate_map(map1)
