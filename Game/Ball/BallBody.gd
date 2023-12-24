extends RigidBody2D

var initial_ball_speed = 500
var min_ball_speed = 200
var speed_reduction = 50
var speed_multiplier = 1.015  # Adjust this multiplier as needed
var max_speed = 1000
var velocity = Vector2.ZERO

# Variable to store the initial x position of the player
var initial_player_x = 0

# Counter to track the number of collisions
var collision_count = 0

func _ready():
	visible = false

func _process(delta):
	# Check for spacebar press to shoot the ball upwards
	if Input.is_action_pressed("ui_accept"):
		if velocity == Vector2.ZERO:
			# Set the initial x position of the player when spacebar is pressed
			initial_player_x = get_parent().get_node("PlayerBody").position.x
			# Set the position and adjust the velocity to make the ball move upwards
			position.x = initial_player_x
			velocity = Vector2(0, -initial_ball_speed)  # Set initial speed
			visible = true

	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collision_normal = collision_info.get_normal()
		velocity = velocity.bounce(collision_normal)
		velocity.x *= speed_multiplier
		velocity.y *= speed_multiplier

		# Check and clamp the magnitude of the velocity
		var current_speed = velocity.length()

		if current_speed > max_speed:
			velocity = velocity.normalized() * max_speed

		# Decrease speed after each collision until reaching the minimum speed
		if initial_ball_speed > min_ball_speed:
			collision_count += 1
			if collision_count % 2 == 0:  # Adjust the frequency of speed reduction
				initial_ball_speed -= speed_reduction
				velocity = velocity.normalized() * initial_ball_speed
				print("Current Ball Speed:", initial_ball_speed)
		else:
			# Apply speed multiplier after reaching the minimum speed
			velocity *= speed_multiplier
			print("Current Ball Speed:", velocity)

func _integrate_forces(state):
	# Override _integrate_forces to prevent external forces from affecting the ball
	state.linear_velocity = velocity
