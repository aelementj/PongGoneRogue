extends Node

var enemy_reference: Node = null  # Reference to the enemy node
var enemy_count: int = 0  # Counter for the number of initiated enemies

func _ready():
	pass  # Replace with function body.

# Function to set the enemy reference
func set_enemy_reference(enemy_node: Node):
	enemy_reference = enemy_node
	enemy_count += 1
	print("Enemy reference set in GlobalScript. Current count:", enemy_count)

# Function to get the enemy reference
func get_enemy_reference() -> Node:
	return enemy_reference

# Function to decrease the enemy count
func decrease_enemy_count():
	enemy_count -= 1
	print("Enemy count decreased. Current count:", enemy_count)

