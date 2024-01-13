extends CharacterBody2D

const BULLET_COOLDOWN = 2.0
const PAUSE = 1.0
const SPEED = 1  # Adjust this value to change the speed of movement

var can_shoot = true
var bullet_timer = Timer.new()
var pause_timer = Timer.new()
var initial_position: Vector2  # Store the initial position
var angle = PI  # Initial angle for circular movement

func _ready():
	# Initialize and connect the bullet timer
	bullet_timer.wait_time = BULLET_COOLDOWN
	bullet_timer.one_shot = true
	bullet_timer.connect("timeout", _on_bullet_timer_timeout)
	add_child(bullet_timer)
	bullet_timer.start()

	pause_timer.wait_time = PAUSE
	pause_timer.one_shot = true
	pause_timer.connect("timeout", _on_pause_timer_timeout)
	add_child(pause_timer)

	initial_position = global_position  # Store the initial position
	EnemyGlobal.instance.addInitiatedEnemy(self)
	EnemyGlobal.instance.updateInitiatedEnemiesCount(EnemyGlobal.instance.initiatedEnemiesCount + 1)

func _physics_process(delta):
	# Check if the player is still valid
	if not is_player_valid():
		return  # Stop processing if the player is not valid

	# Aim towards the player's position
	aim_towards_player()

	# Check if the enemy can shoot
	if can_shoot:
		instantiate_bullet()
		can_shoot = false
		bullet_timer.start()

	# Move the character in a circular trajectory around the initial position
	angle -= SPEED * delta
	var radius = 100  # Adjust this value for the radius of the circle
	var x = initial_position.x + radius * cos(angle)
	var y = initial_position.y + radius * sin(angle)
	global_position = Vector2(x, y)

# Function to aim towards the player's position
func aim_towards_player():
	var player_position = Global.get_player_reference().global_position
	look_at(player_position)

# Function to instantiate the bullet
func instantiate_bullet():
	var bullet_instance = preload("res://Game/Enemies/Bullet/BulletType3.tscn").instantiate()
	bullet_instance.position = global_position
	get_parent().add_child(bullet_instance)

# Function to check if the player is still valid
func is_player_valid() -> bool:
	return Global.get_player_reference() != null

# Function called when the bullet cooldown timer times out
func _on_bullet_timer_timeout():
	$AnimatedSprite2D.stop()
	pause_timer.start()
	can_shoot = true

# Function called when the pause timer times out
func _on_pause_timer_timeout():
	$AnimatedSprite2D.play()

func _exit_tree():
	EnemyGlobal.instance.updateInitiatedEnemiesCount(EnemyGlobal.instance.initiatedEnemiesCount - 1)

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
