extends Node2D

var dungeonGenerator : Node2D

func _ready():
	dungeonGenerator = preload("res://dungeon_crawler.tscn").instantiate()
	add_child(dungeonGenerator)
