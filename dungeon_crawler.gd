extends Node2D

# Exported variables for easy tweaking in the Godot editor
@export var roomWidth: int = 60
@export var roomLength: int = 38
@export var tileSize: float = 16.0

# Preload the PackedScene for the tile and walls
var tileScene: PackedScene = preload("res://Experimental/tile.tscn")
var sideWallScene: PackedScene = preload("res://Experimental/wall.tscn")
var bottomWallScene: PackedScene = preload("res://Experimental/bottom_wall.tscn")
var topWallScene: PackedScene = preload("res://Experimental/top_wall.tscn")
var ballCatcherScene: PackedScene = preload("res://Experimental/ball_catcher.tscn")

func _ready():
	# Call the generateRoom() function when the node is ready
	generateRoom()

func generateRoom() -> void:
	# Calculate the total area that the floor will occupy
	var totalWidth: float = roomWidth * tileSize
	var totalLength: float = roomLength * tileSize

	# Get the center position of the global coordinates
	var center_position = get_viewport_rect().size / 2

	# Calculate the position of the top-left corner of the room in global coordinates
	var roomTopLeft = global_position - Vector2(totalWidth / 2, totalLength / 2)

	# Loop through the specified roomWidth and roomLength
	for x in range(roomWidth):
		for y in range(roomLength):
			# Determine if the current tile is at the bottom edge of the room
			var isBottomEdge: bool = y == roomLength - 1
			var isTopEdge: bool = y == 0

			# Instantiate a tile or wall node from the preloaded scene based on whether it's at the bottom or top edge
			var tile_node: Node

			if isBottomEdge:
				tile_node = bottomWallScene.instantiate()
			elif isTopEdge:
				tile_node = topWallScene.instantiate()
			else:
				# Determine if the current tile is at the side edge of the room
				var isSideEdge: bool = x == 0 or x == roomWidth - 1

				if isSideEdge:
					tile_node = sideWallScene.instantiate()
				else:
					tile_node = tileScene.instantiate()

			# Calculate the position of the tile relative to the top-left corner
			var tile_position = Vector2(x * tileSize, y * tileSize)

			# Set the position of the tile and add it as a child to the current node
			tile_node.global_position = roomTopLeft + tile_position
			add_child(tile_node)

	# Instantiate the ball_catcher line
	for x in range(roomWidth):
		var ballCatcher: Node2D = ballCatcherScene.instantiate()

		# Calculate the position of the ball_catcher relative to the top-left corner
		var ballCatcherPosition = Vector2(x * tileSize - tileSize / 2, (roomLength - 1) * tileSize + tileSize * -4.0)

		# Set the position of the ball_catcher and add it as a child to the current node
		ballCatcher.global_position = roomTopLeft + ballCatcherPosition
		add_child(ballCatcher)
