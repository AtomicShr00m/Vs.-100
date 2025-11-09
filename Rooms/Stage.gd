extends Node2D

var wave:=1
onready var blueScn = preload("res://Objects/Enemies/Blue.tscn")
onready var block_map = $BlockMap
onready var player = $Prime

func _ready():
	spawn_wave()

func spawn_enemy(tile):
	var enemy=blueScn.instance()
	enemy.position=block_map.map_to_world(tile)+Vector2(10,10)
	enemy.target=player
	add_child(enemy)

func spawn_wave():
	var spawn_list:=[]
	for n in 20:
		var lane:=int(n / 5) + 1
		var anchor:=((wave-1) * 64) + 1
		var spawn=Vector2(anchor+(randi()%30),(lane*4) - 1)
		while spawn_list.has(spawn):
			spawn=Vector2(anchor+(randi()%30),(lane*4) - 1)
		spawn_list.append(spawn)
		spawn_enemy(spawn)
