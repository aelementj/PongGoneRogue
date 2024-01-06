extends CharacterBody2D

const SPEED = 50  # Adjust the speed as needed
var custom_velocity = Vector2()
var enemy_position = Vector2()  # Variable to track the enemy's position


func _ready():
	# If custom_velocity is not set externally, randomize it
	if custom_velocity == Vector2():
		if randf() > 0.5:
			custom_velocity.x = SPEED
		else:
			custom_velocity.x = -SPEED
	
	$Timer.start()
	
	EnemyGlobal.set_enemy_reference(self)
	print("Enemy reference set in GlobalScript")

func _process(delta):
	# Check if the player is still valid
	if not is_player_valid():
		$Timer.stop()
		return  # Stop processing if the player is not valid
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

func _on_hit_box_area_entered(area):
	if area.is_in_group("Ball"):
		# Start a delay timer before calling queue_free()
		var delay_timer = Timer.new()
		delay_timer.wait_time = 0.01  # Adjust the delay duration as needed
		delay_timer.one_shot = true
		delay_timer.connect("timeout", _on_delay_timer_timeout)
		add_child(delay_timer)
		delay_timer.start()

# Function called when the delay timer times out
func _on_delay_timer_timeout():
	# This function will be called after the delay
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

func is_player_valid() -> bool:
	return Global.get_player_reference() != null
