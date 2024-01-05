extends CharacterBody2D

const SPEED = 50  # Adjust the speed as needed
const BULLET_COOLDOWN = 2.0  # Adjust the cooldown time as needed

var custom_velocity = Vector2()
var enemy_position = Vector2()
var can_shoot = true
var bullet_timer = Timer.new()

func _ready():
	if randf() > 0.5:
		custom_velocity.x = SPEED
	else:
		custom_velocity.x = -SPEED
	EnemyGlobal.set_enemy_reference(self)
	print("Enemy reference set in Enemy script")


	bullet_timer.wait_time = BULLET_COOLDOWN
	bullet_timer.one_shot = true
	bullet_timer.connect("timeout", _on_bullet_timer_timeout)
	add_child(bullet_timer)
	bullet_timer.start()

func _on_enemytype1_area_entered(area):
	# Check if the entered area is in the "Wall" group
	if area.is_in_group("Wall"):
		# Change the direction when colliding with a wall
		custom_velocity = -custom_velocity

		# Print a debug message
		print("Enemy entered the wall area!")

func _process(delta):
	# Check if the player is still valid
	if not is_player_valid():
		return  # Stop processing if the player is not valid

	# Update the enemy's position
	enemy_position = global_position  # Use global_position to get the global position

	# Move the enemy type 1 horizontally
	velocity = custom_velocity
	move_and_slide()

	# Drop bullets based on alignment with the player
	drop_bullets_on_alignment()

# Function to check if the enemy is aligned with the player on the x-axis
func is_aligned_with_player() -> bool:
	var player_position = Global.get_player_reference().global_position
	return abs(enemy_position.x - player_position.x) < 10  # Adjust the threshold as needed

# Function to drop bullets based on alignment with the player
func drop_bullets_on_alignment():
	if is_aligned_with_player():
		if can_shoot:
			# Drop a bullet just before aligning with the player
			instantiate_bullet(enemy_position)

			# Drop a bullet when aligning with the player
			instantiate_bullet(enemy_position)

			can_shoot = false
			bullet_timer.start()
	else:
		can_shoot = true

# Function to instantiate the bullet
func instantiate_bullet(position: Vector2):
	var bullet_instance = preload("res://Game/Enemies/Bullet/BulletType1.tscn").instantiate()
	bullet_instance.position = position
	get_parent().add_child(bullet_instance)

# Function called when the bullet cooldown timer times out
func _on_bullet_timer_timeout():
	can_shoot = true

# Function to check if the player is still valid
func is_player_valid() -> bool:
	return Global.get_player_reference() != null
