extends CharacterBody2D

const SPEED = 50
const BULLET_COOLDOWN = 2.0

var custom_velocity = Vector2()
var enemy_position = Vector2()
var can_shoot = true
var bullet_timer = Timer.new()

func _ready():
	EnemyGlobal.set_enemy_reference(self)
	print("Enemy reference set in Enemy script")

	# Initialize and connect the timer
	bullet_timer.wait_time = BULLET_COOLDOWN
	bullet_timer.one_shot = true
	bullet_timer.connect("timeout", _on_bullet_timer_timeout)
	add_child(bullet_timer)
	bullet_timer.start()

func _process(delta):
	# Check if the player is still valid
	if not is_player_valid():
		return  # Stop processing if the player is not valid

	# Update the enemy's position
	enemy_position = global_position

	# Calculate direction based on player's x position
	var player_position = Global.get_player_reference().global_position
	custom_velocity.x = (player_position.x > enemy_position.x) ? SPEED : -SPEED

	# Move the enemy horizontally
	move_and_slide(custom_velocity)

	# Check if the enemy is aligned with the player on the x-axis
	if can_shoot and is_aligned_with_player():
		# Instantiate the bullet scene
		instantiate_bullet()
		can_shoot = false
		bullet_timer.start()

# Function to check if the enemy is aligned with the player on the x-axis
func is_aligned_with_player() -> bool:
	var player_position = Global.get_player_reference().global_position
	return abs(enemy_position.x - player_position.x) < 10

# Function to instantiate the bullet
func instantiate_bullet():
	var bullet_instance = preload("res://Game/Enemies/Bullet/BulletType1.tscn").instantiate()
	bullet_instance.position = global_position
	get_parent().add_child(bullet_instance)

# Function called when the bullet cooldown timer times out
func _on_bullet_timer_timeout():
	can_shoot = true

# Function to check if the player is still valid
func is_player_valid() -> bool:
	return Global.get_player_reference() != null
