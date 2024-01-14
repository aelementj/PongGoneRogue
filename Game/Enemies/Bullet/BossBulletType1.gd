extends CharacterBody2D

const SPEED = 250  # Adjust the speed as needed

func _ready():
	$Fire.play()
	
	# Get the player's position
	var player_position = Global.get_player_reference().global_position

	# Calculate the angle towards the player
	var direction_vector = player_position - global_position
	var target_angle = direction_vector.angle()

	# Add a random angle offset for variation
	var random_angle_offset = deg_to_rad(randi_range(-30, 30))  # Adjust the angle range as needed
	target_angle += random_angle_offset

	# Set the bullet velocity based on the modified angle
	velocity = Vector2(SPEED * cos(target_angle), SPEED * sin(target_angle))

	# Rotate the bullet sprite to match the direction angle plus 90 degrees
	rotation_degrees = rad_to_deg(target_angle + PI / 2.0)
	
	$Timer.start()

func _process(delta):
	position += velocity * delta

	# Check if the bullet is out of the screen, then queue_free
	if position.y > get_viewport_rect().size.y:
		queue_free()



func _on_timer_timeout():
	queue_free()
