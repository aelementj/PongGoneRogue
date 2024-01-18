extends CharacterBody2D

const SPEED = 50
const SPEED_MULTIPLIER = 2.0
const BULLET_COOLDOWN = 4
const MAX_BULLETS = 10
const BULLET_DELAY = 0.1

var custom_velocity = Vector2()
var enemy_position = Vector2()
var initial_position = Vector2()
var track_player = true
var can_shoot = true
var bullets_fired = 0
var bullet_timer = Timer.new()
var player = Global.get_player_reference()
var summon_instantiated : bool = false

func _ready():
	EnemyGlobal.instance.addInitiatedEnemy(self)
	EnemyGlobal.instance.updateInitiatedEnemiesCount(EnemyGlobal.instance.initiatedEnemiesCount + 1)
	initial_position = global_position

	# Initialize and connect the bullet timer
	bullet_timer.wait_time = BULLET_COOLDOWN
	bullet_timer.one_shot = true
	bullet_timer.connect("timeout", _on_bullet_timer_timeout)
	add_child(bullet_timer)
	
	$ToggleMovement.start()


func _on_bullet_timer_timeout():
	can_shoot = true
	bullets_fired = 0

func _on_enemytype1_area_entered(area):
	if area.is_in_group("Wall"):
		custom_velocity = -custom_velocity

func _process(delta):
	if not is_player_valid():
		return

	enemy_position = global_position

	if Input.is_action_just_pressed("test7"):
		track_player = !track_player

	if Input.is_action_just_pressed("test8"):
		instantiate_top_summon()
		instantiate_bot_summon()

	if track_player:
		summon_instantiated = false
		update_velocity()
		aim_towards_player()
	else:
		can_shoot = false
		move_to_initial_position()
		if velocity == Vector2(0, 0) and summon_instantiated == false:
			instantiate_top_summon()
			instantiate_bot_summon()
			summon_instantiated = true

	velocity = custom_velocity
	move_and_slide()

	# Check if the enemy can shoot
	if can_shoot and bullets_fired < MAX_BULLETS:
		# Instantiate all the bullets with a delay between each initiation
		instantiate_bullets_sequence()

		can_shoot = false
		bullet_timer.start()

func update_velocity():
	var player_position = Global.get_player_reference().global_position
	var distance_to_player = player_position.x - enemy_position.x
	var speed_multiplier = lerp(1.0, SPEED_MULTIPLIER, abs(distance_to_player) / 100.0)
	custom_velocity.x = sign(distance_to_player) * SPEED * speed_multiplier

func move_to_initial_position():
	custom_velocity.x = sign(initial_position.x - enemy_position.x) * 400
	if abs(enemy_position.x - initial_position.x) < 4.0:
		custom_velocity = Vector2(0, 0)

func is_player_valid() -> bool:
	return Global.get_player_reference() != null

func instantiate_bullets_sequence():
	for i in range(MAX_BULLETS):
		var timer = Timer.new()
		timer.wait_time = i * BULLET_DELAY
		timer.one_shot = true
		timer.connect("timeout", _on_bullet_delay_timeout)
		add_child(timer)
		timer.start()

func _on_bullet_delay_timeout():
	instantiate_bullet()
	bullets_fired += 1

func instantiate_bullet():
	var bullet_instance = preload("res://Game/Enemies/Bullet/BossBulletType2.tscn").instantiate()
	bullet_instance.position = global_position
	get_parent().add_child(bullet_instance)


var lives: int = 8  # Initial number of lives

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

func _on_delay_timer_timeout():
	queue_free()
	print("Enemy Defeated")

func _exit_tree():
	EnemyGlobal.instance.updateInitiatedEnemiesCount(EnemyGlobal.instance.initiatedEnemiesCount - 1)


func aim_towards_player():
	var player_position = Global.get_player_reference().global_position
	look_at(player_position)


func _on_toggle_movement_timeout():
	track_player = !track_player
	can_shoot = true

func instantiate_bot_summon():
	var bot_summon_instance = preload("res://Game/Enemies/StationShotgun.tscn").instantiate()
	bot_summon_instance.position = global_position + Vector2(48, 32)
	get_parent().add_child(bot_summon_instance)
	
func instantiate_top_summon():
	var top_summon_instance = preload("res://Game/Enemies/StationShotgun.tscn").instantiate()
	top_summon_instance.position = global_position + Vector2(-48, 32)
	get_parent().add_child(top_summon_instance)
