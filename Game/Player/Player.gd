# ParentNode of playerbody, and ballbody
extends Node2D

@export var playerBody : Node2D
@export var paddle : Node2D

# Variables to store initial positions
var initialPlayerBodyPosition : Vector2
var initialPaddlePosition : Vector2

# Flag to track whether a ball has been added
var ballAdded : bool = false

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Store the initial positions when the nodes are first initiated in the scene
	initialPlayerBodyPosition = playerBody.position
	initialPaddlePosition = paddle.position
	DoorGlobal.connect("reset_player_position", reset_positions)
	PowerUpGlobal.connect("AddBall", initiate_ball)
	Global.connect("hide_player", hide_when_transitioning)
	Global.connect("show_player", show_after_transitioning)

var ball_spacing: float = 20.0  # Adjust the spacing as needed

func reset_positions() -> void:
	playerBody.position = initialPlayerBodyPosition
	paddle.position = initialPaddlePosition
	Global.reset_ball_pos()

# Function to initiate a BallBody as a child of the node and add it to the balls array
func initiate_ball():
	# Check if a ball has already been added
	if not ballAdded:
		var ball_instance = preload("res://Game/Ball/BallBody.tscn").instantiate() # Replace with the correct path to your BallBody scene
		
		# Position the new ball 20 pixels to the right of the last ball
		if get_child_count() > 0:
			var last_ball = get_child(get_child_count() - 1)
			ball_instance.position = last_ball.position + Vector2(ball_spacing, 0)
		else:
			ball_instance.position = Vector2.ZERO
		
		add_child(ball_instance)  # Replace with the correct path to your PowerUpManager
		PowerUpGlobal.removePowerUp(PowerUpGlobal.ballAddedPowerUp)

		# Add the instantiated ball to the balls array in the Global script
		Global.add_ball(ball_instance)

		# Set the flag to true to indicate that a ball has been added
		ballAdded = true

func hide_when_transitioning():
	hide()
	print("???")

func show_after_transitioning():
	show()
	print("???")

# Input handling
func _input(event):
	if event.is_action_pressed("test1"):
		initiate_ball()

	
	if event.is_action_pressed("test3"):
		Global.reset_ball_pos()

func _on_transition_animation_finished(anim_name):
	pass
