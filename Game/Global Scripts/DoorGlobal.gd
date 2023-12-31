# Globals.gd

extends Node

# Singleton instance
var instance

# Number of initiated doors
var initiatedDoorsCount : int = 0

# Signal emitted when the initiated doors count changes
signal initiated_doors_count_changed(count)

# Dictionary to store power-ups for each door
var doorPowerUps = {}

# Array of available power-up effects
var availablePowerUps : Array = [
	"DoublePoints",
	"IncreaseSpeed",
	"Invisibility",
	"Teleportation",
	"Shield",
	"TimeFreeze"
]

func _ready():
	# Set the singleton instance
	instance = self
	print("Globals instance ready")

	# Shuffle the available power-ups to randomize their order
	availablePowerUps.shuffle()

# Function to update the initiated doors count
func updateInitiatedDoorsCount(count):
	initiatedDoorsCount = count
	emit_signal("initiated_doors_count_changed", initiatedDoorsCount)
	print("Initiated doors count updated:", initiatedDoorsCount)

# Function to set the power-up for a specific door
func assignPowerUpToDoor(doorName):
	if availablePowerUps.size() > 0:
		var assignedPowerUp = availablePowerUps.pop_back()  # Take the last power-up from the array
		doorPowerUps[doorName] = assignedPowerUp
		availablePowerUps.shuffle()
		print("Assigned Power-Up", assignedPowerUp, "to door", doorName)
	else:
		print("No more available power-ups to assign")

# Function to get the power-up for a specific door
func getDoorPowerUp(doorName):
	var powerUp = doorPowerUps.get(doorName, "No Power-Up")
	print("Power-Up for door", doorName, ":", powerUp)
	return powerUp

# Function to clear the power-up from a specific door
func clearPowerUpFromDoor(doorName, powerUp):
	if doorPowerUps.has(doorName) and doorPowerUps[doorName] == powerUp:
		print("Clearing Power-Up", powerUp, "from door", doorName)
		availablePowerUps.append(powerUp)  # Put the power-up back into the available pool
		doorPowerUps.erase(doorName)  # Remove the power-up assignment for the door
	else:
		print("Power-Up", powerUp, "is not assigned to door", doorName)
