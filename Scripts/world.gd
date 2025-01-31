extends Node3D

const Cell = preload("res://Scenes/testcell.tscn")
const Cell_L = preload("res://Scenes/light_cell.tscn")
const Cell_D = preload("res://Scenes/doorcell.tscn")
const Cell_E = preload("res://Scenes/exit_cell.tscn")
const Cell_H = preload("res://Scenes/heal_cell.tscn")
const Cell_WL = preload("res://Scenes/deco_cell_light.tscn")
const Enemy_Tesla = preload("res://Scenes/TelsaBot.tscn")
const Enemy_Boob = preload("res://Scenes/booby_bot.tscn")
const Enemy_Handsy = preload("res://Scenes/HandyBot.tscn")
const Boss = preload("res://Scenes/boss_bot.tscn")
const door_block = preload("res://Scenes/doorblock.tscn")
const map1 = preload("res://Scenes/map.tscn")
const map2 = preload("res://Scenes/map_2.tscn")
const map3 = preload("res://Scenes/map_3.tscn")
const mapBoss = preload("res://Scenes/map_boss.tscn")
const player_new = preload("res://Scenes/player.tscn")

var Cells = []
var Types = [0]
var Enemies = []
var maps = [map2,mapBoss,map1,mapBoss]

@export var Map: PackedScene
@export var Globals: Script
@onready var battleInterface = $BattleInterface
@onready var player = $Player

@onready var ambient = $AudioStreamPlayer2D
@onready var facemelting = $FaceMelt

var map_index = 0
var current_map = maps[map_index]

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
	var light_wall = 9
	var BOSS = 10
	
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
			secret_cell:
				cell = Cell_H.instantiate()
				cell.position=Vector3(tile.x*Globals.GRID_SIZE,0,tile.y*Globals.GRID_SIZE)
			light_wall:
				cell = Cell_WL.instantiate()
				cell.position=Vector3(tile.x*Globals.GRID_SIZE,0,tile.y*Globals.GRID_SIZE)
			BOSS:
				cell = Cell.instantiate()
				cell.position=Vector3(tile.x*Globals.GRID_SIZE,0,tile.y*Globals.GRID_SIZE)
				var new_enemy = Boss.instantiate()
				add_child(new_enemy)
				Enemies.append(new_enemy)
				new_enemy.position=Vector3(tile.x*Globals.GRID_SIZE, 0,tile.y*Globals.GRID_SIZE)
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
	Cells = []
	generate_map(current_map)
	
func remove_bot(deadBot):
	var shit = 0
	
	for enemy in Enemies:
		if deadBot == enemy:
			Enemies.remove_at(shit)
		shit += 1
			

func clear_enemies():
	for enemy in Enemies:
		remove_child(enemy)
		
	Enemies = []
func _ready() -> void:
	generate_map(current_map)
	
func restart():
	clear_enemies()
	player.battleReset()
	clear_map()
	
func next_level():
	clear_enemies()
	map_index+=1
	current_map = maps[map_index]
	if current_map == mapBoss:
		ambient.stop()
		facemelting.play()
	clear_map()
	
