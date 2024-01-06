extends CharacterBody2D

const SPEED = 200  # Adjust the speed as needed

func _ready():
	# Set a random downward angle for the bullet
	var random_angle = deg_to_rad(randi_range(60, 120))  # Adjust the angle range as needed
	velocity = Vector2(SPEED * cos(random_angle), SPEED * sin(random_angle))

	# Rotate the bullet sprite to match the direction angle
	rotation_degrees = rad_to_deg(random_angle + 30)

func _process(delta):
	position += velocity * delta

	# Check if the bullet is out of the screen, then queue_free
	if position.y > get_viewport_rect().size.y:
		queue_free()
