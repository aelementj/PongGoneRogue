extends CharacterBody2D
class_name PaddleBody

var speed: float = 200.0
var player: Node  # Assuming this is set to the player node in _ready()
var following_enabled: bool = true

var teleport_distance: float = 75.0
var teleport_cooldown: float = 3.0
var can_teleport: bool = true

func _ready():
	# Assuming you have a reference to the player node, set it here
	player = Global.get_player_reference()

func _process(delta):
	follow_player()
	process_input()

# Function to follow the player
func follow_player():
	var direction: Vector2 = Vector2.ZERO

	if player and following_enabled:
		direction = (player.global_position - global_position).normalized()

		velocity = direction * speed
		move_and_slide()

		# Check if player is aligned with the center of the paddle's x position
		var tolerance: float = 40.0  # Adjust this value based on your needs
		if abs(player.global_position.x - global_position.x) < tolerance:
			following_enabled = true
		else:
			following_enabled = false
	else:
		velocity = Vector2.ZERO

# Process player input
func process_input():
	if can_teleport and Input.is_action_just_pressed("dash"):
		teleport()
		start_teleport_cooldown()

# Teleport function
func teleport():
	var teleport_direction: Vector2 = (player.global_position - global_position).normalized()
	var teleport_position: Vector2 = position + teleport_direction * teleport_distance

	if is_teleport_position_valid(teleport_position):
		position = teleport_position

# Check if the teleport position is valid (not colliding with anything)
func is_teleport_position_valid(position: Vector2) -> bool:
	var collision: KinematicCollision2D = move_and_collide(position)
	return collision == null

# Start cooldown timer
func start_teleport_cooldown():
	can_teleport = false
	$Timer.start(teleport_cooldown)

# Called when the timer completes (cooldown is over)
func _on_timer_timeout():
	can_teleport = true
