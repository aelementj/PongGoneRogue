extends CharacterBody2D

# Speed of the character
var speed = 200

# Direction of the character
var direction = Vector2()

func _physics_process(delta):
	# Get input direction
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	# Normalize direction
	direction = direction.normalized()

	# Set velocity
	velocity = direction * speed
