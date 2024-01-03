extends Node
class_name GlobalScript

var ball_count : int = 1  # Initial number of balls
var player_reference : Node = null  # Reference to the player node
var shoot_angle : float = 0.0
var player_lives : int = 3  # Initial number of lives

func global_function():
	print("Global function called")

# Function to add a ball to the player's inventory
func add_ball():
	ball_count += 1
	print("Ball added. New ball count: ", ball_count)

# Function to check if the player has at least one ball
func has_ball() -> bool:
	var hasBall : bool = ball_count > 0
	print("Player has at least one ball: ", hasBall)
	return hasBall

# Function to reset the number of balls
func reset_balls():
	ball_count = 1
	print("Balls reset to one.")

# Function to set the player reference
func set_player_reference(player_node: Node):
	player_reference = player_node

# Function to get the player's global position
func get_player_reference() -> Node:
	return player_reference

# Function to decrease player lives
func decrease_player_lives():
	player_lives -= 1
	print("Player lives decreased. Remaining lives: ", player_lives)

# Function to get the current number of player lives
func get_player_lives() -> int:
	return player_lives

# Function to reset the number of lives
func reset_player_lives():
	player_lives = 3  # Reset to the initial number of lives
	print("Player lives reset to ", player_lives)
