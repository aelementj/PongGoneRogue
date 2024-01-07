extends Node2D

# Declare variables for player body, paddle, and ball
@export var playerBody : Node2D
@export var paddle : Node2D
@export var ball : Node2D

# Variables to store initial positions
var initialPlayerBodyPosition : Vector2
var initialPaddlePosition : Vector2
var initialBallPosition : Vector2

# Flag to prevent multiple resets in quick succession
var reset_in_progress : bool = false

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Store the initial positions when the nodes are first initiated in the scene
	initialPlayerBodyPosition = playerBody.position
	initialPaddlePosition = paddle.position
	initialBallPosition = ball.position
	DoorGlobal.instance.connect("positions_reset", reset_positions)

# Function to reset the positions of player body, paddle, and ball to their initial positions
# and stop the movement of the ball
func reset_positions() -> void:
	# Check if a reset is already in progress
	if not reset_in_progress:
		reset_in_progress = true
		# Set the positions to their initial values
		playerBody.position = initialPlayerBodyPosition
		paddle.position = initialPaddlePosition
		ball.position = initialBallPosition
		ball.velocity = Vector2.ZERO
		ball.visible = false
		Global.add_ball()
		print("Player has_Ball: ", Global.has_ball())

		# Add debug prints to verify the function is triggered
		print("Positions reset!")
		print("Player Body Position: ", playerBody.position)
		print("Paddle Position: ", paddle.position)
		print("Ball Position: ", ball.position)

		# Start a timer to allow the next reset after a short delay
		var timer = Timer.new()
		timer.wait_time = 1.0  # Adjust the delay duration as needed
		timer.one_shot = true
		timer.connect("timeout", _on_reset_timer_timeout)
		add_child(timer)
		timer.start()

# Signal emitted when the reset timer times out
func _on_reset_timer_timeout():
	reset_in_progress = false
