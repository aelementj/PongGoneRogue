extends CharacterBody2D

const BULLET_COOLDOWN = 1.0


var bullet_timer = Timer.new()

func _ready():
	# Initialize and connect the bullet timer
	bullet_timer.wait_time = BULLET_COOLDOWN
	bullet_timer.one_shot = false
	bullet_timer.connect("timeout", _on_bullet_timer_timeout)
	add_child(bullet_timer)
	bullet_timer.start()

	EnemyGlobal.instance.addInitiatedEnemy(self)
	EnemyGlobal.instance.updateInitiatedEnemiesCount(EnemyGlobal.instance.initiatedEnemiesCount + 1)
	$Despawn.start()


func _process(delta):
	# Check if the player is still valid
	if not is_player_valid():
		return  # Stop processing if the player is not valid
	aim_towards_player()




# Function to aim towards the player's position
func aim_towards_player():
	var player_position = Global.get_player_reference().global_position
	look_at(player_position)

# Function to check if the player is still valid
func is_player_valid() -> bool:
	return Global.get_player_reference() != null

# Function called when the hit box area is entered
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


const MAX_BULLETS: int = 5
var bullets_fired = 0
var can_shoot: bool = true

func instantiate_bullet():
	var bullet_instance = preload("res://Game/Enemies/Bullet/BossBulletType1.tscn").instantiate()
	bullet_instance.position = global_position
	get_parent().add_child(bullet_instance)
	bullets_fired += 1

func try_shooting():
	if is_player_valid() and can_shoot and bullets_fired < MAX_BULLETS:
		aim_towards_player()

		for i in range(MAX_BULLETS):
			instantiate_bullet()

		can_shoot = false

func _on_bullet_timer_timeout():
	try_shooting()
	can_shoot = true
	bullets_fired = 0



func _on_despawn_timeout():
	queue_free()
