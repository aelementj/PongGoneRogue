extends CharacterBody2D

@export var move_speed: float = 30  # Adjust this value as needed
@export var move_duration: float = 1.0  # Adjust this value as needed
@export var stop_duration: float = 0.5  # Adjust this value as needed
@export var hits_to_destroy: int = 3  # Number of hits needed to destroy the enemy

var original_direction: Vector2 = Vector2.RIGHT
var current_direction: Vector2 = Vector2.RIGHT
var timer: float = 0.0
var is_moving: bool = true
var hits_remaining: int = 3  # Initialize the hits_remaining variable

func _ready():
	original_direction = [Vector2.RIGHT, Vector2.LEFT][randi() % 2]
	current_direction = original_direction

func _physics_process(delta):
	if is_moving:
		var distance_to_move = move_speed * delta

		# Move in the current direction
		var new_position = position + current_direction * distance_to_move
		var collision_info = move_and_collide(new_position - position)

		if collision_info:
			current_direction *= -1
			is_moving = true

	else:
		# Timer to control the stopping duration
		timer -= delta

		if timer <= 0.0:
			# Change direction and start moving again
			current_direction *= -1
			is_moving = true

func _on_area_2d_area_entered(area):
	if area.is_in_group("ball"):
		# If hit by the ball, stop for a brief moment
		is_moving = false
		timer = stop_duration

		# Decrease hits_remaining when hit by the ball
		hits_remaining -= 1

		if hits_remaining <= 0:
			# If hits_remaining is zero or negative, queue_free the enemy
			queue_free()
		else:
			# Reset is_moving to true after the timer expires
			timer = stop_duration
