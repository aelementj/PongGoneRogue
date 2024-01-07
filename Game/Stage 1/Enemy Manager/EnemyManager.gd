# RoomManager.gd
extends Node

# Array to store available enemy template paths
var available_enemy_templates : Array = []

# Array to store instantiated enemy template instances
var instantiated_enemies : Array = []

var instantiation_in_progress : bool = false

func _ready():
	# Initialize available enemy template paths with your 12 enemy templates
	available_enemy_templates = [
		"res://Game/Stage 1/Enemy Manager/EnemyTemplates/EnemyTemplate1.tscn",
		"res://Game/Stage 1/Enemy Manager/EnemyTemplates/EnemyTemplate2.tscn",
		"res://Game/Stage 1/Enemy Manager/EnemyTemplates/EnemyTemplate3.tscn",
		"res://Game/Stage 1/Enemy Manager/EnemyTemplates/EnemyTemplate4.tscn",
		"res://Game/Stage 1/Enemy Manager/EnemyTemplates/EnemyTemplate5.tscn",
		"res://Game/Stage 1/Enemy Manager/EnemyTemplates/EnemyTemplate6.tscn",
		"res://Game/Stage 1/Enemy Manager/EnemyTemplates/EnemyTemplate7.tscn",
		"res://Game/Stage 1/Enemy Manager/EnemyTemplates/EnemyTemplate8.tscn",
		"res://Game/Stage 1/Enemy Manager/EnemyTemplates/EnemyTemplate9.tscn",
		"res://Game/Stage 1/Enemy Manager/EnemyTemplates/EnemyTemplate10.tscn",
		"res://Game/Stage 1/Enemy Manager/EnemyTemplates/EnemyTemplate11.tscn",
		"res://Game/Stage 1/Enemy Manager/EnemyTemplates/EnemyTemplate12.tscn"
	]

	# Shuffle the available enemy templates
	available_enemy_templates.shuffle()
	
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

# Example of how to use the instantiate_new_enemy function
func _process(delta):
	# Check if the "ui_up" action is just pressed
	if Input.is_action_just_pressed("ui_up") and instantiation_in_progress == false:
		# Get the path of the next enemy template from the shuffled array
		if available_enemy_templates.size() > 0:
			var next_enemy_path = available_enemy_templates.pop_back()
			instantiate_new_enemy(next_enemy_path)
		else:
			print("No available enemies")

func _on_ball_entered_any_open_door():
	# Implement the logic to get the path of the next room from the shuffled array
	if available_enemy_templates.size() > 0 and instantiation_in_progress == false:
		var next_enemy_path = available_enemy_templates.pop_back()
		instantiate_new_enemy(next_enemy_path)
	else:
		print("No available rooms")
