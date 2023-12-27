extends Node
class_name GlobalScript

var ball_count : int = 1  # Initial number of balls
var shoot_angle : float = 0.0

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
