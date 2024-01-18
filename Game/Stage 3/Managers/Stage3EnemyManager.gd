# EnemyManager.gd
extends Node

# Array to store available enemy template paths
var available_enemy_templates : Array = []

# Array to store instantiated enemy template instances
var instantiated_enemies : Array = []

# Array to store available boss template paths
var boss_templates : Array = []

# Array to store available elite template paths
var elite_templates : Array = []

var instantiation_in_progress : bool = false

var enemy_count : int = 0
var elite_count : int = 0
var boss_count : int = 0

func _ready():
	# Initialize available enemy template paths with your 12 enemy templates
	available_enemy_templates = [
		"res://Game/Stage 3/enemyTemplates/EnemyTemplate1.C.tscn",
		"res://Game/Stage 3/enemyTemplates/EnemyTemplate2.C.tscn",
		"res://Game/Stage 3/enemyTemplates/EnemyTemplate3.C.tscn",
		"res://Game/Stage 3/enemyTemplates/EnemyTemplate4.C.tscn",
		"res://Game/Stage 3/enemyTemplates/EnemyTemplate5.C.tscn",
		"res://Game/Stage 3/enemyTemplates/EnemyTemplate6.C.tscn",
		"res://Game/Stage 3/enemyTemplates/EnemyTemplate7.C.tscn",
		"res://Game/Stage 3/enemyTemplates/EnemyTemplate8.C.tscn",
		"res://Game/Stage 3/enemyTemplates/EnemyTemplate9.C.tscn",
		"res://Game/Stage 3/enemyTemplates/EnemyTemplate10.C.tscn",
		"res://Game/Stage 3/enemyTemplates/EnemyTemplate11.C.tscn",
		"res://Game/Stage 3/enemyTemplates/EnemyTemplate12.C.tscn",
	]

	# Initialize available boss template paths with your boss templates
	boss_templates = [
		"res://Game/Stage 3/bossTemplates/BossTemplate3.tscn",
		# Add more boss templates as needed
	]

	# Initialize available elite template paths with your elite templates
	elite_templates = [
		"res://Game/Stage 1/Enemy Manager/EliteTemplates/EliteTemplate1.tscn",
		"res://Game/Stage 1/Enemy Manager/EliteTemplates/EliteTemplate2.tscn",
		"res://Game/Stage 1/Enemy Manager/EliteTemplates/EliteTemplate3.tscn",
		"res://Game/Stage 1/Enemy Manager/EliteTemplates/EliteTemplate4.tscn"
		# Add more elite templates as needed
	]
	
	available_enemy_templates.shuffle()
	boss_templates.shuffle()
	elite_templates.shuffle()
	
	DoorGlobal.instance.connect("ball_entered_any_open_door", _on_ball_entered_any_open_door)

func instantiate_new_enemy(enemy_path: String):
	if instantiation_in_progress:
		# Enemy instantiation is already in progress, skip
		return

	instantiation_in_progress = true

	if instantiated_enemies.size() > 0:
		var last_instantiated_enemy = instantiated_enemies.pop_back()
		last_instantiated_enemy.queue_free()
		print("Removed Enemy: ", last_instantiated_enemy.get_name())

	var new_enemy_instance = load(enemy_path).instantiate()
	add_child.call_deferred(new_enemy_instance)
	instantiated_enemies.append(new_enemy_instance)
	print("Instantiated EnemyTemplate: ", enemy_path)

	print("Remaining EnemiesTemplates:", available_enemy_templates)
	print("Remaining EliteTemplates:", elite_templates)
	print("Remaining BossTemplates:", boss_templates)

	# Allow the next instantiation after a short delay
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.connect("timeout", _on_instantiation_timer_timeout)
	add_child(timer)
	timer.name = "Timer"
	timer.start()

func _on_instantiation_timer_timeout():
	instantiation_in_progress = false
	var timer = get_node("Timer")
	if timer:
		timer.queue_free()

func _process(delta):
	if Input.is_action_just_pressed("clear"):
		_on_ball_entered_any_open_door()

func _on_ball_entered_any_open_door():
	if instantiation_in_progress:
		# Enemy instantiation is already in progress, skip
		return

	var next_enemy_path: String = ""

	if enemy_count < 3 and available_enemy_templates.size() > 0 and instantiation_in_progress == false:
		# Load the next enemy template
		next_enemy_path = available_enemy_templates.pop_back()
		enemy_count += 1
	elif elite_count < 1 and available_enemy_templates.size() > 0 and instantiation_in_progress == false:
		# Load the next elite template
		next_enemy_path = elite_templates.pop_back()
		elite_count += 1
	elif enemy_count < 5 and elite_count == 1  and available_enemy_templates.size() > 0 and instantiation_in_progress == false:
		# Load the next enemy template
		next_enemy_path = available_enemy_templates.pop_back()
		enemy_count += 1
	elif boss_count < 1 and available_enemy_templates.size() > 0 and instantiation_in_progress == false:
		# Load the next boss template
		next_enemy_path = boss_templates.pop_back()
		boss_count += 1

	if next_enemy_path != "":
		instantiate_new_enemy(next_enemy_path)
	else:
		print("No available enemies")
