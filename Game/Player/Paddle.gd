extends CharacterBody2D
class_name PaddleBody

var speed: float = 0
var player: Node  # Assuming this is set to the player node in _ready()
var following_enabled: bool = true
var follow_distance: float = 50.0  # Adjust this value based on your needs
var can_teleport: bool = true
var teleport_distance: float = 50.0
var teleport_cooldown: float = 0
var player_valid: bool = false
# Variable to store the previous position
var previous_position: Vector2 = Vector2.ZERO

func _ready():
	# Assuming you have a reference to the player node, set it here
	player = Global.get_player_reference()
	player_valid = is_player_valid()

func _process(delta):
	if player_valid and player.has_method("is_moving") and player.is_moving():
		follow_player()
		process_input()
		speed = player.speed
		teleport_cooldown = player.teleport_cooldown
		can_teleport = player.can_teleport
		# Update previous position
		previous_position = position
	else:
		velocity = Vector2.ZERO
		following_enabled = false
		player_valid = is_player_valid()
		
# Function to follow the player
func follow_player():
	var direction: Vector2 = Vector2.ZERO

	direction = (player.position - position).normalized()

	velocity = direction * speed
	move_and_slide()

	# Check if the player is within a certain distance to the right or left
	var distance_to_player: float = abs(player.global_position.x - global_position.x)
	if distance_to_player < follow_distance:
		following_enabled = true
	else:
		following_enabled = false
		velocity = Vector2.ZERO

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

	# Check if the player is defeated, then queue-free the paddle
	if Global.get_player_lives() <= 0:
		hide()


