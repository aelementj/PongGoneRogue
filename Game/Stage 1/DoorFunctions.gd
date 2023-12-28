extends Node2D

var closedDoor: Area2D
var openDoor: Area2D

func _ready():
	# Assuming you have the closed door and open door areas as children
	closedDoor = $Closed
	openDoor = $Open

	# Disable the collision shape of the closed door initially
	openDoor.get_node("CollisionShape2D").disabled = true

	# Connect the signal for collision with the open door
	openDoor.connect("body_entered", _on_open_door_body_entered)

func _process(delta):
	# Check for the condition to open the door, for example, the down button or "ui_down"
	if Input.is_action_just_pressed("ui_down"):
		# Toggle the visibility and collision shapes of the doors
		toggleDoors()

func toggleDoors():
	# Toggle the visibility of the doors
	closedDoor.visible = !closedDoor.visible
	openDoor.visible = !openDoor.visible

	# Toggle the collision shapes
	closedDoor.get_node("CollisionShape2D").disabled = !closedDoor.get_node("CollisionShape2D").disabled
	openDoor.get_node("CollisionShape2D").disabled = !openDoor.get_node("CollisionShape2D").disabled

func _on_open_door_body_entered(body):
	# Check if the entering body is the ball
	if body.is_in_group("Ball"):
		# Call a function or perform an action when the ball enters the open door
		onBallEnterOpenDoor()

func onBallEnterOpenDoor():
	# Implement your logic here when the ball enters the open door
	print("Ball entered the open door!")
	# Add any additional actions or functions you want to perform
