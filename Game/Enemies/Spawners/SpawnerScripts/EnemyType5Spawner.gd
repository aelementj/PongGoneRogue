extends CharacterBody2D

var health = 3  # Adjust the initial health as needed
var max_shooters = 2
var current_top_shooters = 0
var current_bottom_shooters = 0

var enemy_scenes = preload("res://Game/Enemies/EnemyShotgun.tscn")

var top_shooter: Node = null
var bottom_shooter: Node = null

var top_shooter_removed = false
var bottom_shooter_removed = false

var respawn_timer_top: Timer
var respawn_timer_bottom: Timer

func _ready():
	spawn_shooters()
	EnemyGlobal.instance.addInitiatedEnemy(self)
	EnemyGlobal.instance.updateInitiatedEnemiesCount(EnemyGlobal.instance.initiatedEnemiesCount + 1)
	EnemyGlobal.instance.addInitiatedSpawner(self)
	EnemyGlobal.instance.updateInitiatedSpawnersCount(EnemyGlobal.instance.initiatedSpawnersCount + 1)

	# Create and configure the respawn timers
	respawn_timer_top = Timer.new()
	respawn_timer_top.one_shot = true
	respawn_timer_top.wait_time = 3.0
	add_child(respawn_timer_top)
	respawn_timer_top.connect("timeout", _on_respawn_timer_top_timeout)

	respawn_timer_bottom = Timer.new()
	respawn_timer_bottom.one_shot = true
	respawn_timer_bottom.wait_time = 3.0
	add_child(respawn_timer_bottom)
	respawn_timer_bottom.connect("timeout", _on_respawn_timer_bottom_timeout)

func spawn_shooters():
	# Spawn new shooters if the maximum number of shooters is not reached
	spawn_top_shooter()
	spawn_bottom_shooter()

func spawn_top_shooter():
	if current_top_shooters < max_shooters:
		top_shooter = enemy_scenes.instantiate()

		# Set the initial direction of the top shooter
		if randf() > 0.5:
			top_shooter.custom_velocity.x = top_shooter.SPEED
		else:
			top_shooter.custom_velocity.x = -top_shooter.SPEED

		current_top_shooters += 1

		# Set the position of the top shooter based on the initial position
		top_shooter.position = position + Vector2(0, -36)  # Adjust the Y-coordinate as needed

		# Use call_deferred with add_child
		get_parent().call_deferred("add_child", top_shooter)

func spawn_bottom_shooter():
	if current_bottom_shooters < max_shooters:
		bottom_shooter = enemy_scenes.instantiate()

		# Set the initial direction of the bottom shooter opposite to the top shooter
		if top_shooter.custom_velocity.x > 0:
			bottom_shooter.custom_velocity.x = -bottom_shooter.SPEED
		else:
			bottom_shooter.custom_velocity.x = bottom_shooter.SPEED

		current_bottom_shooters += 1

		# Set the position of the bottom shooter based on the initial position
		bottom_shooter.position = position + Vector2(0, 36)  # Adjust the Y-coordinate as needed

		# Use call_deferred with add_child
		get_parent().call_deferred("add_child", bottom_shooter)

func _process(delta):
	# Check if top_shooter is null and start the respawn timer for the top shooter
	if not top_shooter_removed and (not top_shooter or top_shooter.is_queued_for_deletion()):
		current_top_shooters -= 1
		top_shooter_removed = true
		respawn_timer_top.start()
		$Timer.start()

	# Check if bottom_shooter is null and start the respawn timer for the bottom shooter
	if not bottom_shooter_removed and (not bottom_shooter or bottom_shooter.is_queued_for_deletion()):
		current_bottom_shooters -= 1
		bottom_shooter_removed = true
		respawn_timer_bottom.start()
		$Timer.start()

func _on_respawn_timer_top_timeout():
	# Reset the removed flag for the top shooter
	top_shooter_removed = false

	# Instantiate a new top shooter
	spawn_top_shooter()
	$Timer.stop()

func _on_respawn_timer_bottom_timeout():
	# Reset the removed flag for the bottom shooter
	bottom_shooter_removed = false

	# Instantiate a new bottom shooter
	spawn_bottom_shooter()
	$Timer.stop()

func on_Ball_area_entered(area):
	if area.is_in_group("Ball"):
		# Check if the object entering the area is in the "Ball" group
		health -= 1
		print("Spawner Hit")
		if health <= 0:
			print("Spawner Destroyed")
			queue_free()

func _exit_tree():
	EnemyGlobal.instance.updateInitiatedEnemiesCount(EnemyGlobal.instance.initiatedEnemiesCount - 1)
	EnemyGlobal.instance.updateInitiatedSpawnersCount(EnemyGlobal.instance.initiatedSpawnersCount - 1)


func _on_timer_timeout():
	$Spawn.play()
