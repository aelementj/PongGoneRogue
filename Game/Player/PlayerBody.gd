extends CharacterBody2D

# Declare member variables here. Examples:
var speed : float = 200.0
var teleport_distance : float = 50.0  # Adjust this to your desired teleport distance
var teleport_cooldown : float = 3.0  # Cooldown in seconds
var can_teleport : bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Process input and update player movement
	process_input()

# Process player input
func process_input():
	var direction : Vector2 = Vector2.ZERO

	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	elif Input.is_action_pressed("ui_right"):
		direction.x += 1

	# Teleport on spacebar press if the cooldown is over
	if can_teleport and Input.is_action_just_pressed("dash"):
		teleport(direction)
		start_teleport_cooldown()

	velocity = direction.normalized() * speed

	move_and_slide()

# Teleport function
func teleport(direction: Vector2):
	var teleport_position : Vector2 = position + direction.normalized() * teleport_distance

	# Check if the teleport position is valid (not colliding with anything)
	if is_teleport_position_valid(teleport_position):
		position = teleport_position

# Check if the teleport position is valid (not colliding with anything)
func is_teleport_position_valid(position: Vector2) -> bool:
	var collision : KinematicCollision2D = move_and_collide(position - global_position)
	return collision == null  # If there is no collision, the position is valid

# Start cooldown timer
func start_teleport_cooldown():
	can_teleport = false
	$Timer.start(teleport_cooldown)

# Called when the timer completes (cooldown is over)
func _on_timer_timeout():
	can_teleport = true
