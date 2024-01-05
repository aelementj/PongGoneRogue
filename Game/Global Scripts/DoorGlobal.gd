# DoorGlobal.gd

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

# Function to add a reference to an initiated door
func addInitiatedDoor(door):
	initiatedDoors.append(door)
	print("Added reference to initiated door:", door)

# Function to get references to all initiated doors in the current scene
func getInitiatedDoors():
	return initiatedDoors

signal ball_entered_any_open_door
signal positions_reset

func onBallEnterAnyOpenDoor():
	print("DoorGlobal: Ball entered any open door!")
	emit_signal("ball_entered_any_open_door")
	emit_signal("positions_reset")
