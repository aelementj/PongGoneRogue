extends Node

var instance
var initiatedDoorsCount : int = 0
var initiatedDoors : Array = []  # Array to store references to initiated doors in the current scene

# Signal emitted when the initiated doors count changes
signal initiated_doors_count_changed(count)

func _ready():
	# Set the singleton instance
	instance = self
	print("Globals instance ready")

# Function to update the initiated doors count
func updateInitiatedDoorsCount(count):
	initiatedDoorsCount = count
	emit_signal("initiated_doors_count_changed", initiatedDoorsCount)
	print("Initiated doors count updated:", initiatedDoorsCount)

func addInitiatedDoor(door):
	initiatedDoors.append(door)

func removeInitiatedDoor(door):
	initiatedDoors.erase(door)
	updateInitiatedDoorsCount(initiatedDoorsCount - 1)

# Function to get references to all initiated doors in the current scene
func getInitiatedDoors():
	return initiatedDoors

func onBallEnterAnyOpenDoor():
	print("DoorGlobal: Ball entered any open door!")
	emit_signal("ball_entered_any_open_door")
	emit_signal("reset_player_position")
	emit_signal("reset_ball_position")

func thankyou():
	emit_signal("demo2")
	print("debugdg")

signal demo2

# Signal emitted when any open door is entered by the ball
signal ball_entered_any_open_door

# Signal emitted when positions need to be reset
signal reset_ball_position
signal reset_player_position

# Function to toggle the doors open
func toggleDoors():
	for door in initiatedDoors:
		door.toggleDoors()

func areAllInitiatedDoorsToggled() -> bool:
	for door in initiatedDoors:
		# Check if the door is not queue freed and not toggled
		if door != null and !door.hasToggledDoor:
			return false

	# All doors have been toggled or are queue freed
	return true
