extends CharacterBody2D

const SPEED = 50  # Adjust the speed as needed
var custom_velocity = Vector2()
var enemy_position = Vector2()  # Variable to track the enemy's position

func _process(delta):
	# Update the enemy's position
	enemy_position = position

	# Move the enemy horizontally
	velocity = custom_velocity
	move_and_slide()

	# Check if the player is below the enemy
	var player_position = Global.get_player_position()
	if player_position.y < position.y:
		# Instantiate a bullet
		instantiate_bullet()

func instantiate_bullet():
	# Instantiate the bullet scene
	var bullet_instance = preload("res://Game/Enemies/Bullet/BulletType1.tscn").instance()

	# Set the bullet's initial position to the enemy's position
	bullet_instance.position = position

	# Add the bullet to the scene
	get_parent().add_child(bullet_instance)
