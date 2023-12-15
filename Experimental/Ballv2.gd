extends CharacterBody2D

class_name Ballv2

@export var initial_ball_speed = 20
@export var speed_multiplier = 1.01
@export var max_speed = 100  # Adjust this value to set the maximum speed

signal ball_caught  # New signal declaration

var ball_speed = initial_ball_speed

func initialize_ball(player_position: Vector2, room_length: int, tile_size: float) -> void:
	# Set the ball's initial position right above the player
	global_position = player_position + Vector2(0, -room_length * tile_size / 20)

	# Set the initial velocity
	velocity.x = [0.8, -0.8][randi() % 2]
	velocity.y = initial_ball_speed
	
	

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta * initial_ball_speed)
	if collision_info:
		var collision_normal = collision_info.get_normal()
		velocity = velocity.bounce(collision_normal)
		velocity.x *= speed_multiplier
		velocity.y *= speed_multiplier

	# Check and clamp the magnitude of the velocity
	var current_speed = velocity.length()

	if current_speed > max_speed:
		velocity = velocity.normalized() * max_speed



func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		print("Hit enemy!")
	
	if area.is_in_group("ball_catcher"):
		print("Caught by ball_catcher!")
		velocity = Vector2.ZERO

