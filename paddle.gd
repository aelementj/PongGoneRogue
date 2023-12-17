extends RigidBody2D

@export var speed: float = 30000
@export var dash_speed: float = 50
@export var dash_cooldown: float = 2.0  # Cooldown period in seconds
var lives: int = 3
var current_room_position: Vector2  # Variable to store the paddle's position in the room
var is_dashing: bool = false
var dash_duration: float = 0.2
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0

func _ready():
	# Set linear_damp to zero for less resistance
	linear_damp = 0.0

func _physics_process(delta):
	var movement = Vector2.ZERO

	if Input.is_action_pressed("ui_left"):
		movement.x -= 1
	elif Input.is_action_pressed("ui_right"):
		movement.x += 1

	# Dash logic
	if Input.is_action_just_pressed("dash") and not is_dashing and dash_cooldown_timer <= 0.0:
		# Check for collisions before dashing
		var new_position = global_position + movement.normalized() * dash_speed
		if not check_collision(new_position):
			start_dash(movement.normalized())

	# Update the current_room_position variable
	current_room_position = global_position

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dashing = false
			linear_velocity = Vector2.ZERO
			dash_cooldown_timer = dash_cooldown
	else:
		linear_velocity = movement.normalized() * speed * delta

	# Cooldown logic
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta

	# Stop the object when no keys are pressed
	if movement == Vector2.ZERO:
		linear_velocity = Vector2.ZERO

func check_collision(new_position: Vector2) -> bool:
	# Perform collision check with side walls
	var collision_info = move_and_collide(new_position - global_position)
	return collision_info != null

func _on_Paddle_body_entered(body):
	# Check if the colliding body is the ball
	if body.is_in_group("ball"):
		# Check the relative motion of the ball and the paddle
		var relative_velocity = linear_velocity - body.linear_velocity
		var dot_product = relative_velocity.dot(linear_velocity.normalized())

		# If the dot product is negative, the ball is moving towards the paddle
		# Prevent the paddle from being carried along by the ball
		if dot_product < 0:
			# Calculate the impulse to stop the paddle from sliding
			var impulse = body.mass * relative_velocity
			apply_impulse(Vector2(), impulse)

			# Ensure the paddle does not get affected by the collision
			linear_velocity = Vector2.ZERO

func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		# Bullet hit the paddle
		lives -= 1
		if lives <= 0:
			# Game over or handle losing logic
			print("Game Over")
			queue_free()
		else:
			print("Lives Remaining:", lives)

func start_dash(direction: Vector2) -> void:
	is_dashing = true
	dash_timer = dash_duration
	global_position += direction * dash_speed
