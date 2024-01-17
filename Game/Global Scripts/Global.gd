extends Node
class_name GlobalScript

# Member Variables
var ball_count : int = 0
var player_reference : Node = null
var balls : Array = []  # Array to store referenced balls
var shoot_angle : float = 0.0
var player_lives : int = 3  # Initial number of lives
var ball_reference : Node = null  # Declare ball_reference as a class member
var current_ball_index : int = 0  # Track the current index in the array
var max_ball_count : int = 0
var mana_count : int = 1
var max_mana_count : int = 3

# Signals
signal ball_increased
signal ball_decreased
signal reset_ball_position
signal lives_decreased
signal lives_increased
signal mana_increased
signal mana_decreased

# Global Function
func global_function():
	print("Global function called")

func get_initiated_balls() -> Array:
	return balls

# Ball Management Functions
func add_ball(ball: Node):
	if ball_count < max_ball_count:
		ball_count += 1
		emit_signal("ball_increased")
		print("Ball added. New ball count: ", ball_count)

		# Store the referenced ball in the array
		balls.append(ball)
	else:
		print("Max ball count reached. Cannot add more balls.")

func minus_ball(ball_node: Node):
	if ball_node != null and balls.has(ball_node):
		balls.erase(ball_node)
		ball_count -= 1
		emit_signal("ball_decreased")
		print("Ball removed. New ball count: ", ball_count)
	print(balls)

func has_ball() -> bool:
	return ball_count > 0

func reset_balls():
	ball_count = 0
	max_ball_count = 0
	print("Balls reset to zero.")
	balls.clear()  # Clear the array when resetting balls

# Ball Position Functions
func reset_ball_pos():
	emit_signal("reset_ball_position")

# Player and Ball Reference Functions
func set_player_reference(player_node: Node):
	player_reference = player_node

func get_player_reference() -> Node:
	return player_reference

func set_ball_reference(ball_node: Node):
	ball_reference = ball_node
	add_ball(ball_node)  # Add the referenced ball to the array

func get_ball_reference() -> Node:
	return ball_reference

# Player Lives Functions
func decrease_player_lives():
	player_lives -= 1
	emit_signal("lives_decreased")
	print("Player lives decreased. Remaining lives: ", player_lives)

func increase_player_lives():
	player_lives += 1
	emit_signal("lives_increased")
	print("Player lives increased. Remaining lives: ", player_lives)

func get_player_lives() -> int:
	return player_lives

func reset_player_lives():
	player_lives = 3
	print("Player lives reset to ", player_lives)

# Ball Index and Movement Functions
func get_topmost_ball() -> Node:
	if balls.size() > 0:
		return balls[balls.size() - 1]  # Return the last element in the array (topmost ball)
	else:
		return null  # Return null if the array is empty

func get_ball_count():
	return ball_count

func get_ball_index(ball: Node) -> int:
	if balls.size() > 0:
		for i in range(balls.size()):
			if balls[i] == ball:
				return i
	return -1  # Return -1 if the ball is not found in the array

func get_next_ball() -> Node:
	if balls.size() > 0:
		var next_ball = balls[current_ball_index]
		return next_ball
	else:
		return null

# Function to move to the next ball in the array
func move_to_next_ball():
	if balls.size() > 0:
		current_ball_index = (current_ball_index + 1) % balls.size()

# Player Mana Functions
func decrease_player_mana():
	mana_count -= 1
	emit_signal("mana_decreased")
	print("Player mana decreased. Remaining mana: ", mana_count)

func increase_player_mana():
	mana_count += 1
	emit_signal("mana_increased")
	print("Player mana increased. Remaining mana: ", mana_count)

func increase_mana_cap():
	max_mana_count += 1

func reduce_mana_cd():
	emit_signal("reduce_cd_mana")
signal reduce_cd_mana

func reset_mana_cd():
	emit_signal("reset_cd_mana")
	print("mana cd resetted")
signal reset_cd_mana

func reset_player_mana():
	mana_count = 3
	max_mana_count = 3
	print("Player mana reset to ", mana_count)

func _process(delta):
	if Input.is_action_just_pressed("test9"):
		spawn_player()
	if Input.is_action_just_pressed("test0"):
		player_hide()
	if ball_count != balls.size():
		reset_ball_pos()

var player: Node = null
func spawn_player():
	var playerbody = preload("res://Game/Player/Player.tscn")
	player = playerbody.instantiate()
	get_parent().add_child(player)

func remove_player():
	player.queue_free()

func player_hide():
	emit_signal("hide_player")
	reset_ball_pos()
signal hide_player

func player_show():
	emit_signal("show_player")
signal show_player
