extends CharacterBody2D

const SPEED = 50  # Adjust the base speed as needed
const SPEED_MULTIPLIER = 2.0  # Adjust the speed multiplier as needed
const BULLET_COOLDOWN = 2.0  # Adjust the cooldown time as needed
const PAUSE_AFTER_SHOOT = 1.0  # Adjust the pause duration after shooting

var custom_velocity = Vector2()
var enemy_position = Vector2()
var can_shoot = true
var can_move = true  # New variable to control movement
var bullet_timer = Timer.new()
var pause_timer = Timer.new()

func _ready():
	if randf() > 0.5:
		custom_velocity.x = SPEED
	else:
		custom_velocity.x = -SPEED
	EnemyGlobal.instance.addInitiatedEnemy(self)
	EnemyGlobal.instance.updateInitiatedEnemiesCount(EnemyGlobal.instance.initiatedEnemiesCount + 1)

	# Initialize and connect the bullet timer
	bullet_timer.wait_time = BULLET_COOLDOWN
	bullet_timer.one_shot = true
	bullet_timer.connect("timeout", _on_bullet_timer_timeout)
	add_child(bullet_timer)
	bullet_timer.start()

	# Initialize and connect the pause timer
	pause_timer.wait_time = PAUSE_AFTER_SHOOT
	pause_timer.one_shot = true
	pause_timer.connect("timeout", _on_pause_timer_timeout)
	add_child(pause_timer)

func _on_enemytype1_area_entered(area):
	# Check if the entered area is in the "Wall" group
	if area.is_in_group("Wall"):
		# Change the direction when colliding with a wall
		custom_velocity = -custom_velocity


func _process(delta):
	# Check if the player is still valid
	if not is_player_valid():
		return  # Stop processing if the player is not valid

	# Update the enemy's position
	enemy_position = global_position  # Use global_position to get the global position
	
	if can_move:
		# Get the player's position
		var player_position = Global.get_player_reference().global_position

		# Calculate the distance to the player
		var distance_to_player = player_position.x - enemy_position.x

		# Adjust the speed based on the distance to the player
		var speed_multiplier = lerp(1.0, SPEED_MULTIPLIER, abs(distance_to_player) / 100.0)
		custom_velocity.x = sign(distance_to_player) * SPEED * speed_multiplier

		# Move the enemy type 1 horizontally
		velocity = custom_velocity
		move_and_slide()

	# Check if the enemy is aligned with the player on the x-axis
	if can_shoot and is_aligned_with_player():
		# Instantiate the bullet scene
		instantiate_bullet()
		can_shoot = false
		bullet_timer.start()
		can_move = false  # Disable movement after shooting
		pause_timer.start()

# Function to check if the enemy is aligned with the player on the x-axis
func is_aligned_with_player() -> bool:
	var player_position = Global.get_player_reference().global_position
	return abs(enemy_position.x - player_position.x) < 10  # Adjust the threshold as needed

# Function to instantiate the bullet
func instantiate_bullet():
	var bullet_instance = preload("res://Game/Enemies/Bullet/BulletType1.tscn").instantiate()
	bullet_instance.position = global_position  # Set bullet position to the enemy's position
	get_parent().add_child(bullet_instance)

# Function called when the bullet cooldown timer times out
func _on_bullet_timer_timeout():
	can_shoot = true

# Function to check if the player is still valid
func is_player_valid() -> bool:
	return Global.get_player_reference() != null

# Function called when the pause timer times out
func _on_pause_timer_timeout():
	can_move = true  # Enable movement after the pause duration

var lives: int = 2  # Initial number of lives

func _on_hit_box_area_entered(area):
	if area.is_in_group("Ball"):
		lives -= 1

		# Check if there are still lives remaining
		if lives > 0:
			print("Lives remaining:", lives)
		else:
			print("No more lives!")
			# Trigger game over or reset logic here

		# Wait for 8 hits before calling the timer
		if lives <= 0:
			var delay_timer = Timer.new()
			delay_timer.wait_time = 0.01
			delay_timer.one_shot = true
			delay_timer.connect("timeout", _on_delay_timer_timeout)
			add_child(delay_timer)
			delay_timer.start()

# Function called when the delay timer times out
func _on_delay_timer_timeout():
	# This function will be called after the delay
	queue_free()
	print("Enemy Defeated")

func _exit_tree():
	EnemyGlobal.instance.updateInitiatedEnemiesCount(EnemyGlobal.instance.initiatedEnemiesCount - 1)
