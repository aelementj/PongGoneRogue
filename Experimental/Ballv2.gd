extends CharacterBody2D

class_name Ballv2

@export var initial_ball_speed = 15
@export var speed_multiplier = 1.05

var ball_speed = initial_ball_speed

func initialize_ball(player_position: Vector2, room_length: int, tile_size: float) -> void:
	# Set the ball's initial position right above the player
	global_position = player_position + Vector2(0, -room_length * tile_size / 20)

	# Set the initial velocity
	velocity.x = [0.2, -0.2][randi() % 2]
	velocity.y = initial_ball_speed

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta * initial_ball_speed)
	if collision_info:
		var collision_normal = collision_info.get_normal()
		velocity = velocity.bounce(collision_normal)
		velocity.x *= speed_multiplier
		velocity.y *= speed_multiplier
