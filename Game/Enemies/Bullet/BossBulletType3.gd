extends CharacterBody2D

const SPEED = 400  # Adjust the speed as needed
const ANGLE_DEVIATION = 0.1  # Adjust the deviation amount as needed

func _ready():
	$Fire.play()

	# Get the player's position
	var player_position = Global.get_player_reference().global_position

	# Calculate the angle towards the player with deviation
	var direction_vector = player_position - global_position
	var target_angle = direction_vector.angle()

	# Add deviation to the target angle
	var deviation = randf_range(-ANGLE_DEVIATION, ANGLE_DEVIATION)
	target_angle += deviation

	# Set the bullet velocity based on the calculated angle
	velocity = Vector2(SPEED * cos(target_angle), SPEED * sin(target_angle))

	# Rotate the bullet sprite to match the direction angle plus 90 degrees
	rotation_degrees = rad_to_deg(target_angle + PI / 2.0)

func _process(delta):
	position += velocity * delta

	# Check if the bullet is out of the screen, then queue_free
	if position.y > get_viewport_rect().size.y:
		queue_free()
