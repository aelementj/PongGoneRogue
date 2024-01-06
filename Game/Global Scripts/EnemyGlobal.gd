extends Node

var enemy_reference: Node = null  # Reference to the enemy node
var enemy_count: int = 0  # Counter for the number of initiated enemies

var spawner_reference: Node = null  # Reference to a single spawner
var spawner_count: int = 0  # Counter for the number of initiated spawners

func _ready():
	pass  # Replace with function body.

# Function to set the enemy reference
func set_enemy_reference(enemy_node: Node):
	enemy_reference = enemy_node
	enemy_count += 1
	print("Enemy reference set in GlobalScript. Current enemy count:", enemy_count)

# Function to get the enemy reference
func get_enemy_reference() -> Node:
	return enemy_reference

# Function to decrease the enemy count
func decrease_enemy_count():
	enemy_count -= 1
	print("Enemy count decreased. Current enemy count:", enemy_count)

# Function to set the spawner reference
func set_spawner_reference(spawner_node: Node):
	spawner_reference = spawner_node
	spawner_count += 1
	print("Spawner reference set in GlobalScript. Current spawner count:", spawner_count)

# Function to get the spawner reference
func get_spawner_reference() -> Node:
	return spawner_reference

# Function to decrease the spawner count
func decrease_spawner_count():
	spawner_count -= 1
	print("Spawner count decreased. Current spawner count:", spawner_count)
