extends CharacterBody2D

const SPEED = 100
var custom_velocity = Vector2()
var enemy_position = Vector2()


# Preload the laser beam scene
var laser_beam_scene = preload("res://Game/Enemies/Bullet/BulletType4.tscn")

func _ready():
	custom_velocity.x = -SPEED
	
	$Timer.start()
	
	EnemyGlobal.instance.addInitiatedEnemy(self)
	EnemyGlobal.instance.updateInitiatedEnemiesCount(EnemyGlobal.instance.initiatedEnemiesCount + 1)
	var queue_free_timer = Timer.new()
	queue_free_timer.wait_time = 5.0
	queue_free_timer.one_shot = true
	queue_free_timer.connect("timeout", _on_queue_free_timer_timeout)
	add_child(queue_free_timer)
	queue_free_timer.start()

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
	# Instantiate the laser beam scene
	var laser_beam_instance = laser_beam_scene.instantiate()
	add_child(laser_beam_instance)

func is_player_valid() -> bool:
	return Global.get_player_reference() != null

# Function called when the node is about to be removed from the scene tree
func _exit_tree():
	EnemyGlobal.instance.updateInitiatedEnemiesCount(EnemyGlobal.instance.initiatedEnemiesCount - 1)

func _on_queue_free_timer_timeout():
	queue_free()
