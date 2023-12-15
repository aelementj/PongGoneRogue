extends Node2D

var dungeonGenerator: Node2D
var player: Node2D
var ball: Ballv2

func _ready():
	# Instantiate and add the dungeon generator
	dungeonGenerator = preload("res://dungeon_crawler.tscn").instantiate()
	add_child(dungeonGenerator)

	# Call a function to initiate the player
	initPlayer()

	# Call a function to initiate the ball
	initBall()

func initPlayer() -> void:
	# Instantiate and add the player
	player = preload("res://paddle.tscn").instantiate()

	# Set the player's initial position to the global position
	player.global_position = global_position

	# Move the player down 1/5 of the room area
	var moveDownDistance = (dungeonGenerator.roomLength * dungeonGenerator.tileSize) / 3
	player.translate(Vector2(0, moveDownDistance))

	# Add the player as a child of the main scene
	add_child(player)

func initBall() -> void:
	# Instantiate and add the ball
	ball = preload("res://Experimental/Ballv2.tscn").instantiate()
	
	# Initialize the ball's position and velocity
	ball.initialize_ball(player.global_position, dungeonGenerator.roomLength, dungeonGenerator.tileSize)

	# Add the ball as a child of the main scene
	add_child(ball)
