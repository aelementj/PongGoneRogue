extends CharacterBody2D

class_name Ballv2

@export var initial_ball_speed: float = 20
@export var speed_multiplier: float = 1.01
@export var max_speed: float = 100
@onready var initialization_timer: Timer = $Timer

var ball_speed: float = initial_ball_speed
var initial_position: Vector2
var paddle_reference: Node2D  # Store a reference to the paddle
var is_caught: bool = false  # Flag to track if the ball is caught

# Accessing values from the room scene
var roomScene = preload("res://dungeon_crawler.tscn").instantiate()
var width = roomScene.getRoomWidth()
var length = roomScene.getRoomLength()
var size = roomScene.getTileSize()

func initialize_ball(paddle_position: Vector2, room_length: int, tile_size: float) -> void:
	# Set the ball's initial position right above the player
	initial_position = paddle_position + Vector2(0, -room_length * tile_size / 20)
	global_position = initial_position / 5

	# Calculate the direction from the ball to the paddle
	var direction_to_paddle = (paddle_position - global_position).normalized()

	# Set the initial velocity using the direction towards the paddle
	velocity = direction_to_paddle * initial_ball_speed

func _ready():
	initialize_ball(Vector2.ZERO, length, size)  # You might want to pass the actual values here

func _physics_process(delta):
	if is_caught:
		# If the ball is caught, do nothing
		return

	var collision_info = move_and_collide(velocity * delta * initial_ball_speed)
	if collision_info:
		var collision_normal = collision_info.get_normal()
		velocity = velocity.bounce(collision_normal)
		velocity.x *= speed_multiplier
		velocity.y *= speed_multiplier

		# Check and clamp the magnitude of the velocity
		var current_speed = velocity.length()

		if current_speed > max_speed:
			velocity = velocity.normalized() * max_speed
		
		$Bounce.play()



func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		print("Hit enemy!")

	if area.is_in_group("ball_catcher"):
		print("Caught by ball_catcher!")
		is_caught = true
		velocity = Vector2.ZERO

# Add a new function to handle the ball caught logic
func ball_caught():
	# Reset the flag and set the ball's velocity to move towards the paddle
	is_caught = false
	initialize_ball(paddle_reference.global_position, length, size)

# Function to pass a reference to the paddle to the ball
func set_paddle_reference(paddle):
	paddle_reference = paddle

func _on_ball_touched_area_entered(area):
	if area.is_in_group("paddle") and is_caught:
		# Instead of queue_free, hide or deactivate the ball
		hide()
		$Timer.start()

func _on_timer_timeout():
	$Timer.stop()
	# After the timer, reinitialize or show the ball
	ball_caught()
	show()  # or any other method to activate the ball
