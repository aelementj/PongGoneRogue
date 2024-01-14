extends CharacterBody2D

var SPEEDMULIPLIER: float = 4.0
var SPEED: int = 50
var custom_velocity = Vector2()
var enemy_position = Vector2()
var initial_position = Vector2()
var reduce_speed: bool = false
var speed_reduction_rate: int = 0
var current_direction: Vector2 = Vector2(1, 0)

var tracking_mode: bool = true
var speed_reduction_count: int = 0
var laser_initiation : int = 0

func _ready():
	if custom_velocity == Vector2():
		custom_velocity.x = SPEED

	$Timer.start()

	EnemyGlobal.instance.addInitiatedEnemy(self)
	EnemyGlobal.instance.updateInitiatedEnemiesCount(EnemyGlobal.instance.initiatedEnemiesCount + 1)

	initial_position = position
	
	$ToggleMovement.start()


func _process(delta):
	if reduce_speed:
		_reduce_speed(delta)

	enemy_position = position

	if tracking_mode:
		_tracking_movement()
		_initial_speed()
		try_shooting()
		increase_speed_count = 0

	else:
		_left_side_movement()
		if increase_speed_count < 2 and speed_reduction_rate == 0:
			_increase_speed()
			print(increase_speed_count)
			
var increase_speed_count: int = 0


func _reduce_speed(delta):
	if speed_reduction_rate > 0:
		custom_velocity = custom_velocity.lerp(Vector2(), delta * speed_reduction_rate)
		if custom_velocity.length_squared() < 0.01:
			custom_velocity = Vector2()
			reduce_speed = false
			_initial_speed()
			try_shooting()
			can_shoot = true
			bullets_fired = 0

			speed_reduction_count += 1

var left_shooter_scene = preload("res://Game/Enemies/ShowerShooterLR.tscn")
var right_shooter_scene = preload("res://Game/Enemies/ShowerShooterRL.tscn")

func instantiate_left_shooter():
	var spawn_offset = Vector2(0, 50)
	var shooter_instance = left_shooter_scene.instantiate()
	shooter_instance.position = global_position + spawn_offset
	get_parent().add_child(shooter_instance)
	laser_initiation += 1
	print(laser_initiation)

func instantiate_right_shooter():
	var spawn_offset = Vector2(0, 50)
	var shooter_instance = right_shooter_scene.instantiate()
	shooter_instance.position = global_position + spawn_offset
	get_parent().add_child(shooter_instance)
	laser_initiation += 1
	print(laser_initiation)

func _tracking_movement():
	var player_position = Global.get_player_reference().global_position
	var distance_to_player = player_position.x - enemy_position.x
	var speed_multiplier = lerp(1.0, SPEEDMULIPLIER, abs(distance_to_player) / 100.0)
	custom_velocity.x = sign(distance_to_player) * SPEED * speed_multiplier

	velocity = custom_velocity
	move_and_slide()

func _left_side_movement():
	velocity = custom_velocity
	move_and_slide()

func _toggle_movement_mode():
	tracking_mode = not tracking_mode
	
	if tracking_mode:
		$Shoot.start()
		print("Switched to Tracking Movement")
	else:
		$Shoot.stop()
		can_shoot = true
		bullets_fired = 0
		print("Switched to Left Side Movement")

func _return_to_initial_position():
	var direction = (initial_position - position).normalized()
	current_direction = direction
	custom_velocity = current_direction * SPEED

func _initial_speed():
	SPEED = 50
	speed_reduction_rate = 0
	_return_to_initial_position()

func _increase_speed():
	SPEED = 500
	speed_reduction_rate = 10
	custom_velocity = current_direction * SPEED
	increase_speed_count += 1

func _reduce_speed_on_wall_hit():
	reduce_speed = true

func _on_enemytype1_area_entered(area):
	if area.is_in_group("Wall"):
		current_direction = -current_direction
		custom_velocity = current_direction * SPEED

		if speed_reduction_rate > 0:
			_reduce_speed_on_wall_hit()
			if speed_reduction_count % 2 == 0:
				instantiate_left_shooter()
			else:
				instantiate_right_shooter()

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

func get_enemy_position():
	return enemy_position

func is_player_valid() -> bool:
	return Global.get_player_reference() != null

func _exit_tree():
	EnemyGlobal.instance.updateInitiatedEnemiesCount(EnemyGlobal.instance.initiatedEnemiesCount - 1)

func aim_towards_player():
	if is_player_valid():
		var player_position = Global.get_player_reference().global_position
		look_at(player_position)

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


func _on_toggle_movement_timeout():
	_toggle_movement_mode()


func _on_shoot_timeout():
	try_shooting()
	can_shoot = true
	bullets_fired = 0
