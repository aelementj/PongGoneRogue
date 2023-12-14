extends Node2D

# Set the size of the grid
var grid_size = Vector2(10, 10)
var tile_size = Vector2(64, 64)

# Array to store the generated tiles
var floor_tiles = []

func _ready():
	generate_floor()

func generate_floor():
	# Loop through the grid
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			# Create a new tile instance
			var tile = Tile.instance()
			
			# Set the tile position based on the grid and tile size
			tile.position = Vector2(x * tile_size.x, y * tile_size.y)
			
			# Add the tile to the scene
			add_child(tile)
			
			# Add the tile to the array for reference
			floor_tiles.append(tile)

# Custom Tile class
class_name Tile
extends Sprite

func _ready():
	# Set the default texture or load your own
	texture = preload("res://path/to/your/tile_texture.png")
