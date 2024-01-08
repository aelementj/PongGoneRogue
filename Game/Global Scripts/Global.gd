extends Node
class_name GlobalScript

var ball_count : int = 1  # Initial number of balls
var player_reference : Node = null  # Reference to the player node
var ball_reference : Node = null  # Reference to the ball node
var shoot_angle : float = 0.0
var player_lives : int = 3  # Initial number of lives

func global_function():
	print("Global function called")

signal ball_increased
func add_ball():
	ball_count += 1
	emit_signal("ball_increased")
	print("Ball added. New ball count: ", ball_count)

signal ball_decreased
func minus_ball():
	ball_count -= 1
	emit_signal("ball_decreased")
	print("Ball added. New ball count: ", ball_count)

# Function to check if the player has at least one ball
func has_ball() -> bool:
	var hasBall : bool = ball_count > 0
	return hasBall

# Function to reset the number of balls
func reset_balls():
	ball_count = 1
	print("Balls reset to one.")

func reset_ball_pos():
	emit_signal("reset_ball_pos2")
signal reset_ball_pos2

# Function to set the player reference
func set_player_reference(player_node: Node):
	player_reference = player_node

# Function to get the player's global position
func get_player_reference() -> Node:
	return player_reference

# Function to set the ball reference
func set_ball_reference(ball_node: Node):
	ball_reference = ball_node

# Function to get the ball reference
func get_ball_reference() -> Node:
	return ball_reference

signal lives_decreased
func decrease_player_lives():
	player_lives -= 1
	emit_signal("lives_decreased")
	print("Player lives decreased. Remaining lives: ", player_lives)

signal lives_increased
func increase_player_lives():
	player_lives += 1
	emit_signal("lives_increased")
	print("Player lives increased. Remaining lives: ", player_lives)

# Function to get the current number of player lives
func get_player_lives() -> int:
	return player_lives

func get_ball_count() -> int:
	return ball_count

# Function to reset the number of lives
func reset_player_lives():
	player_lives = 3  # Reset to the initial number of lives
	print("Player lives reset to ", player_lives)
