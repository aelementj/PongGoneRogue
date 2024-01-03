extends Node

var enemy_reference: Node = null  # Reference to the enemy node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_enemy_reference(enemy_node: Node):
	enemy_reference = enemy_node
	print("Enemy reference set in GlobalScript")

# Function to get the enemy reference
func get_enemy_reference() -> Node:
	return enemy_reference
