extends CharacterBody2D

var health = 3
var max_shooters = 1
var current_top_shooters = 0
var current_bottom_shooters = 0
var current_left_shooters = 0
var current_right_shooters = 0

var enemy_scenes = preload("res://Game/Enemies/EnemySniper.tscn")

var top_shooter: Node = null
var bottom_shooter: Node = null
var left_shooter: Node = null
var right_shooter: Node = null

var top_shooter_removed = false
var bottom_shooter_removed = false
var left_shooter_removed = false
var right_shooter_removed = false

var respawn_timer_top: Timer
var respawn_timer_bottom: Timer
var respawn_timer_left: Timer
var respawn_timer_right: Timer

var initiation_timer_top: Timer
var initiation_timer_bottom: Timer
var initiation_timer_left: Timer
var initiation_timer_right: Timer

func _ready():
	EnemyGlobal.instance.addInitiatedEnemy(self)
	EnemyGlobal.instance.updateInitiatedEnemiesCount(EnemyGlobal.instance.initiatedEnemiesCount + 1)
	EnemyGlobal.instance.addInitiatedSpawner(self)
	EnemyGlobal.instance.updateInitiatedSpawnersCount(EnemyGlobal.instance.initiatedSpawnersCount + 1)

	# Create and configure the respawn timers
	respawn_timer_top = Timer.new()
	respawn_timer_top.one_shot = true
	respawn_timer_top.wait_time = 8.0
	add_child(respawn_timer_top)
	respawn_timer_top.connect("timeout", _on_respawn_timer_top_timeout)

	respawn_timer_bottom = Timer.new()
	respawn_timer_bottom.one_shot = true
	respawn_timer_bottom.wait_time = 8.0
	add_child(respawn_timer_bottom)
	respawn_timer_bottom.connect("timeout", _on_respawn_timer_bottom_timeout)

	respawn_timer_left = Timer.new()
	respawn_timer_left.one_shot = true
	respawn_timer_left.wait_time = 8.0
	add_child(respawn_timer_left)
	respawn_timer_left.connect("timeout", _on_respawn_timer_left_timeout)

	respawn_timer_right = Timer.new()
	respawn_timer_right.one_shot = true
	respawn_timer_right.wait_time = 8.0
	add_child(respawn_timer_right)
	respawn_timer_right.connect("timeout", _on_respawn_timer_right_timeout)

	# Create and configure the initiation timers
	initiation_timer_top = Timer.new()
	initiation_timer_top.one_shot = false  # Repeating timer
	initiation_timer_top.wait_time = 1.5  # Adjust the initiation interval as needed
	add_child(initiation_timer_top)
	initiation_timer_top.connect("timeout", _on_initiation_timer_top_timeout)
	initiation_timer_top.start()

	initiation_timer_bottom = Timer.new()
	initiation_timer_bottom.one_shot = false  # Repeating timer
	initiation_timer_bottom.wait_time = 0.5  # Adjust the initiation interval as needed
	add_child(initiation_timer_bottom)
	initiation_timer_bottom.connect("timeout", _on_initiation_timer_bottom_timeout)
	initiation_timer_bottom.start()

	initiation_timer_left = Timer.new()
	initiation_timer_left.one_shot = false  # Repeating timer
	initiation_timer_left.wait_time = 2.0  # Adjust the initiation interval as needed
	add_child(initiation_timer_left)
	initiation_timer_left.connect("timeout", _on_initiation_timer_left_timeout)
	initiation_timer_left.start()

	initiation_timer_right = Timer.new()
	initiation_timer_right.one_shot = false  # Repeating timer
	initiation_timer_right.wait_time = 1.0  # Adjust the initiation interval as needed
	add_child(initiation_timer_right)
	initiation_timer_right.connect("timeout", _on_initiation_timer_right_timeout)
	initiation_timer_right.start()


func spawn_top_shooter():
	if current_top_shooters < max_shooters:
		top_shooter = enemy_scenes.instantiate()
		current_top_shooters += 1
		top_shooter.position = position + Vector2(0, -36)
		get_parent().call_deferred("add_child", top_shooter)

func spawn_bottom_shooter():
	if current_bottom_shooters < max_shooters:
		bottom_shooter = enemy_scenes.instantiate()
		current_bottom_shooters += 1
		bottom_shooter.position = position + Vector2(0, 36)
		get_parent().call_deferred("add_child", bottom_shooter)

func spawn_left_shooter():
	if current_left_shooters < max_shooters:
		left_shooter = enemy_scenes.instantiate()
		current_left_shooters += 1
		left_shooter.position = position + Vector2(-36, 0)
		get_parent().call_deferred("add_child", left_shooter)

func spawn_right_shooter():
	if current_right_shooters < max_shooters:
		right_shooter = enemy_scenes.instantiate()
		current_right_shooters += 1
		right_shooter.position = position + Vector2(36, 0)
		get_parent().call_deferred("add_child", right_shooter)

func _process(delta):
	if not top_shooter_removed and (not top_shooter or top_shooter.is_queued_for_deletion()):
		current_top_shooters -= 1
		top_shooter_removed = true
		respawn_timer_top.start()

	if not bottom_shooter_removed and (not bottom_shooter or bottom_shooter.is_queued_for_deletion()):
		current_bottom_shooters -= 1
		bottom_shooter_removed = true
		respawn_timer_bottom.start()

	if not left_shooter_removed and (not left_shooter or left_shooter.is_queued_for_deletion()):
		current_left_shooters -= 1
		left_shooter_removed = true
		respawn_timer_left.start()

	if not right_shooter_removed and (not right_shooter or right_shooter.is_queued_for_deletion()):
		current_right_shooters -= 1
		right_shooter_removed = true
		respawn_timer_right.start()

func _on_respawn_timer_top_timeout():
	top_shooter_removed = false
	spawn_top_shooter()

func _on_respawn_timer_bottom_timeout():
	bottom_shooter_removed = false
	spawn_bottom_shooter()

func _on_respawn_timer_left_timeout():
	left_shooter_removed = false
	spawn_left_shooter()

func _on_respawn_timer_right_timeout():
	right_shooter_removed = false
	spawn_right_shooter()

func _on_initiation_timer_top_timeout():
	if not current_top_shooters == 1:
		spawn_top_shooter()
		current_top_shooters += 1
	else:
		initiation_timer_top.stop()
		initiation_timer_top.disconnect("timeout", _on_initiation_timer_top_timeout)
		print("disconnected")

func _on_initiation_timer_bottom_timeout():
	if not current_bottom_shooters == 1:
		spawn_bottom_shooter()
		current_bottom_shooters += 1
	else:
		initiation_timer_bottom.stop()
		initiation_timer_bottom.disconnect("timeout", _on_initiation_timer_bottom_timeout)
		print("disconnected")

func _on_initiation_timer_left_timeout():
	if not current_left_shooters == 1:
		spawn_left_shooter()
		current_left_shooters += 1
	else:
		initiation_timer_left.stop()
		initiation_timer_left.disconnect("timeout", _on_initiation_timer_left_timeout)
		print("disconnected")

func _on_initiation_timer_right_timeout():
	if not current_right_shooters == 1:
		spawn_right_shooter()
		current_right_shooters += 1
	else:
		initiation_timer_right.stop()
		initiation_timer_right.disconnect("timeout", _on_initiation_timer_right_timeout)
		print("disconnected")

func on_Ball_area_entered(area):
	if area.is_in_group("Ball"):
		health -= 1
		print("Spawner Hit")
		if health <= 0:
			print("Spawner Destroyed")
			queue_free()

func _exit_tree():
	EnemyGlobal.instance.updateInitiatedEnemiesCount(EnemyGlobal.instance.initiatedEnemiesCount - 1)
	EnemyGlobal.instance.updateInitiatedSpawnersCount(EnemyGlobal.instance.initiatedSpawnersCount - 1)

