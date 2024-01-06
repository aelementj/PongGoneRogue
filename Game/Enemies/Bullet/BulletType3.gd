extends CharacterBody2D

const SPEED = 200  # Adjust the speed as needed

func _ready():
	# Get the player's position
	var player_position = Global.get_player_reference().global_position

	# Calculate the angle towards the player
	var direction_vector = player_position - global_position
	var target_angle = direction_vector.angle()

	# Set the bullet velocity based on the calculated angle
	velocity = Vector2(SPEED * cos(target_angle), SPEED * sin(target_angle))

	# Rotate the bullet sprite to match the direction angle plus 90 degrees
	rotation_degrees = rad_to_deg(target_angle + PI / 2.0)

func _process(delta):
	position += velocity * delta

	# Check if the bullet is out of the screen, then queue_free
	if position.y > get_viewport_rect().size.y:
		queue_free()
