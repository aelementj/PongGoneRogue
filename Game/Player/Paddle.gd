extends CharacterBody2D
class_name PaddleBody

var speed: float = 200.0
var player: Node  # Assuming this is set to the player node in _ready()
var following_enabled: bool = true
var follow_distance: float = 50.0  # Adjust this value based on your needs

var teleport_distance: float = 50.0
var teleport_cooldown: float = 2.0
var can_teleport: bool = true

# Variable to store the previous position
var previous_position: Vector2 = Vector2.ZERO

func _ready():
	# Assuming you have a reference to the player node, set it here
	player = Global.get_player_reference()

func _process(delta):
	follow_player()
	process_input()

# Function to follow the player
func follow_player():
	var direction: Vector2 = Vector2.ZERO

	if is_player_valid() and player.has_method("is_moving") and player.is_moving():
		direction = (player.global_position - global_position).normalized()

		velocity = direction * speed
		move_and_slide()

		# Check if the player is within a certain distance to the right or left
		var distance_to_player: float = abs(player.global_position.x - global_position.x)
		if distance_to_player < follow_distance:
			following_enabled = true
		else:
			following_enabled = false

		# Update previous position
		previous_position = global_position
	else:
		velocity = Vector2.ZERO
		following_enabled = false

# Function to check if the player is valid (still instanced in the scene)
func is_player_valid() -> bool:
	return player != null

func teleport(direction: Vector2):
	var teleport_position: Vector2 = position + direction.normalized() * teleport_distance

	# Check if the destination position is valid
	if is_valid_teleport_position(teleport_position):
		position = teleport_position

# Check if the teleport position is valid (not colliding with obstacles)
func is_valid_teleport_position(teleport_position: Vector2) -> bool:
	var collision_info = move_and_collide(teleport_position - position)
	
	# Check if there is no collision (collision_info will be null if no collision occurred)
	return collision_info == null

# Start cooldown timer
func start_teleport_cooldown():
	can_teleport = false
	$Timer.start(teleport_cooldown)

# Called when the timer completes (cooldown is over)
func _on_timer_timeout():
	can_teleport = true

func is_moving() -> bool:
	var moving: bool = velocity.length() > 0.1
	return moving

# Process player input
func process_input():
	if is_player_valid():
		show()
	
	var direction: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	elif Input.is_action_pressed("ui_right"):
		direction.x += 1

	if can_teleport and Input.is_action_just_pressed("dash"):
		teleport(direction)
		start_teleport_cooldown()

	# Check if the player is defeated, then queue-free the paddle
	if Global.get_player_lives() <= 0:
		hide()


