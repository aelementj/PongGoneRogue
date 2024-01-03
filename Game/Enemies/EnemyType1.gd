extends CharacterBody2D

const SPEED = 50  # Adjust the speed as needed
var custom_velocity = Vector2()
var enemy_position = Vector2()  # Variable to track the enemy's position

func _process(delta):
	# Update the enemy's position
	enemy_position = position

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
	
	$Timer.start()


func _on_hit_box_area_entered(area):
	if area.is_in_group("Ball"):
		queue_free()
		print("Enemy Defeated")

# Function to get the current enemy position
func get_enemy_position():
	return enemy_position

# Function called when the shoot_timer times out
func _on_shoot_timer_timeout():
	# Instantiate the bullet scene
	var bullet_instance = preload("res://Game/Enemies/Bullet/BulletType1.tscn").instantiate()

	# Set the bullet's initial position to the enemy's position
	bullet_instance.position = get_enemy_position()

	# Add the bullet to the scene
	get_parent().add_child(bullet_instance)


