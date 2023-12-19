# experimental_room.gd

extends Node2D

var dungeonGenerator: Node2D
var player: Node2D
var ball: Ballv2
var enemy: Node2D
var leftDoorScene: PackedScene = preload("res://Experimental/left_door.tscn")
var rightDoorScene: PackedScene = preload("res://Experimental/right_door.tscn")
var gameoverControl: Control


func _ready():
	# Instantiate and add the dungeon generator
	dungeonGenerator = preload("res://dungeon_crawler.tscn").instantiate()

	# Move the dungeonGenerator node to the right by 0.5 tiles
	dungeonGenerator.global_position.x += dungeonGenerator.getTileSize() / 2

	add_child(dungeonGenerator)

	# Call a function to initiate the player
	initPlayer()

	# Call a function to initiate the ball
	initBall()

	# Call a function to initiate the enemy
	initEnemy()
	
	gameoverControl = $Control
	
func initPlayer() -> void:
	# Instantiate and add the player
	player = preload("res://paddle.tscn").instantiate()

	# Set the player's initial position to the global position
	player.global_position = global_position

	# Move the player down 1/5 of the room area
	var moveDownDistance = (dungeonGenerator.getRoomLength() * dungeonGenerator.getTileSize()) / 2.8
	player.translate(Vector2(0, moveDownDistance))

	# Add the player as a child of the main scene
	add_child(player)

	# Initialize doors
	initDoors()
	
func initDoors() -> void:
	# Initialize left doors
	for i in range(3):
		var leftDoor: Node2D = leftDoorScene.instantiate()
		var leftDoorPosition = Vector2(
			(-(dungeonGenerator.getRoomWidth() * dungeonGenerator.getTileSize()) + 32) / 2,
			player.global_position.y + i * 16  # Adjust the vertical spacing as needed
		)
		leftDoor.global_position = leftDoorPosition
		add_child(leftDoor)

	# Initialize right doors
	for i in range(3):
		var rightDoor: Node2D = rightDoorScene.instantiate()
		var rightDoorPosition = Vector2(
			((dungeonGenerator.getRoomWidth() * dungeonGenerator.getTileSize()) - 32) / 2,
			player.global_position.y + i * 16  # Adjust the vertical spacing as needed
		)
		rightDoor.global_position = rightDoorPosition
		add_child(rightDoor)


func initBall() -> void:
	# Instantiate and add the ball
	ball = preload("res://Experimental/Ballv2.tscn").instantiate()

	# Initialize the ball's position and velocity
	ball.initialize_ball(player.global_position, dungeonGenerator.getRoomLength(), dungeonGenerator.getTileSize())

	# Add the ball as a child of the main scene
	add_child(ball)

	# Pass a reference to the paddle to the ball
	ball.set_paddle_reference(player)

func initEnemy() -> void:
	# Instantiate and add the enemy
	enemy = preload("res://Experimental/enemy.tscn").instantiate()

	# Set the enemy's initial position (adjust as needed)
	var moveUpDistance = (dungeonGenerator.getRoomLength()) * -6
	enemy.translate(Vector2(0, moveUpDistance))

	# Add the enemy as a child of the main scene
	add_child(enemy)

func _on_player_death():
	# Player has died, show the game over panel
	gameoverControl.visible = true
	print("Game over panel shown")
