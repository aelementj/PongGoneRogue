extends CharacterBody2D

const SPEED = 50  # Adjust the speed as needed
var custom_velocity = Vector2()

func _process(delta):
	# Move the enemytype1 horizontally
	velocity = custom_velocity
	move_and_slide()

func _on_enemytype1_area_entered(area):
	# Check if the entered area is in the "Wall" group
	if area.is_in_group("Wall"):
		# Change the direction when colliding with a wall
		custom_velocity = -custom_velocity

		# Print a debug message
		print("Enemy entered the wall area!")

# Called when the node enters the scene tree for the first time
func _ready():
	# Randomly determine the initial direction
	if randf() > 0.5:
		custom_velocity.x = SPEED
	else:
		custom_velocity.x = -SPEED
	
	
func _on_hit_box_area_entered(area):
	if area.is_in_group("Ball"):
		queue_free()
		print("Enemy Defeated")
