extends Panel

# Variables
var heartScene = preload("res://Game/Player/PlayerHearts.tscn")  # Replace with the actual path
var ballScene = preload("res://Game/Player/PlayerBalls.tscn")
var heartVisual: HBoxContainer
var ballVisual: HBoxContainer
var currentHearts: int = 0
var currentBalls: int = 0

func _ready():
	# Assuming the HBoxContainers are direct children
	heartVisual = $VBoxContainer/HealthVisualRow1
	ballVisual = $VBoxContainer/BallVisualRow2
	currentHearts = Global.get_player_lives()
	currentBalls = Global.get_ball_count()
	updateHeartVisual()
	updateBallVisual()
	Global.connect("lives_decreased", removeHeart)
	Global.connect("lives_increased", addHeart)
	Global.connect("ball_increased", addBall)
	Global.connect("ball_decreased", removeBall)

func updateHeartVisual():
	# Remove existing hearts
	for child in heartVisual.get_children():
		child.queue_free()

	# Add hearts based on the current number
	for i in range(currentHearts):
		var heartInstance = heartScene.instantiate()
		heartVisual.add_child(heartInstance)

# Example of how to update the number of hearts
func addHeart():
	currentHearts += 1
	updateHeartVisual()

func removeHeart():
	currentHearts -= 1
	updateHeartVisual()

func updateBallVisual():
	# Remove existing hearts
	for child in ballVisual.get_children():
		child.queue_free()

	# Add hearts based on the current number
	for i in range(currentBalls):
		var ballInstance = ballScene.instantiate()
		ballVisual.add_child(ballInstance)

func addBall():
	currentBalls += 1
	updateBallVisual()

func removeBall():
	currentBalls -= 1
	updateBallVisual()
