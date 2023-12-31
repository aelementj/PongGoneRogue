# Door.gd

extends Node2D

var closedDoor: Area2D
var openDoor: Area2D
var indicatorLabel: Label

func _ready():
	DoorGlobal.instance.updateInitiatedDoorsCount(DoorGlobal.instance.initiatedDoorsCount + 1)
	print("Door ", DoorGlobal.instance.initiatedDoorsCount)
	# Assuming you have the closed door and open door areas as children
	closedDoor = $Closed
	openDoor = $Open
	indicatorLabel = $IndicatorLabel  # Add a Label node for the indicator text

	# Disable the collision shape of the closed door initially
	openDoor.get_node("CollisionShape2D").disabled = true

	# Connect the signal for collision with the open door
	openDoor.connect("body_entered", _on_open_door_body_entered)

	# Initialize the indicator label
	updateIndicatorLabel()

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

	# Check if the door is now open
	if openDoor.visible:
		# Assign a unique power-up to this door
		assignPowerUp()
	else:
		# Clear the power-up when the door is closed
		clearPowerUp()

func assignPowerUp():
	# Get the name of this door
	var doorName = self.get_name()

	# Check if the door has already been assigned a power-up
	if DoorGlobal.instance.getDoorPowerUp(doorName) == "No Power-Up":
		# If not assigned, assign a power-up
		DoorGlobal.instance.assignPowerUpToDoor(doorName)
		# Update the indicator label with the assigned power-up
		updateIndicatorLabelWithPowerUp()

func clearPowerUp():
	# Get the name of this door
	var doorName = self.get_name()

	# Get the power-up assigned to this door
	var powerUp = DoorGlobal.instance.getDoorPowerUp(doorName)

	# Clear the power-up assigned to this door
	DoorGlobal.instance.clearPowerUpFromDoor(doorName, powerUp)

	# Update the indicator label to indicate no power-up
	updateIndicatorLabel()

func updateIndicatorLabel():
	indicatorLabel.text = "???"

func updateIndicatorLabelWithPowerUp():
	# Get the name of this door
	var doorName = self.get_name()

	# Get the power-up assigned to this door
	var powerUp = DoorGlobal.instance.getDoorPowerUp(doorName)

	# Update the indicator label with the assigned power-up
	indicatorLabel.text = powerUp

func _on_open_door_body_entered(body):
   # Check if the entering body is the ball
	if body.is_in_group("Ball"):
	  # Call a function or perform an action when the ball enters the open door
		onBallEnterOpenDoor()

func onBallEnterOpenDoor():
   # Implement your logic here when the ball enters the open door
	print("Ball entered the open door!")
   # Add any additional actions or functions you want to perform
