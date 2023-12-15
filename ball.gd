extends CharacterBody2D

class_name Ball

@export var initial_ball_speed = 15
@export var speed_multiplier = 1.05

var ball_speed = initial_ball_speed

func initialize_ball(player_position: Vector2, room_length: int, tile_size: float) -> void:
	# Set the ball's initial position right above the player
	global_position = player_position + Vector2(0, -room_length * tile_size / 5.0)

	# Set the initial velocity
	velocity.x = [0.2, -0.2][randi() % 2]
	velocity.y = initial_ball_speed

func reflect(incident: Vector2, normal: Vector2) -> Vector2:
	# Ensure the normal is normalized
	var reflection_normal = normal.normalized()
	
	# Calculate the reflection vector
	return incident - 2 * reflection_normal * incident.dot(reflection_normal)

func _physics_process(delta):
	var collision = move_and_collide(velocity * ball_speed * delta)
	if (collision):
		# Calculate the reflection based on the collision normal
		velocity = reflect(velocity, collision.get_normal()) * speed_multiplier
