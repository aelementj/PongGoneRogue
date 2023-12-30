# RoomManager.gd

extends Node

# Array to store available room paths
var available_rooms : Array = []

# Array to store instantiated room instances
var instantiated_rooms : Array = []

func _ready():
	# Initialize available room paths with your 12 room scenes
	available_rooms = [
		"res://Game/Stage 1/Room 01.tscn",
		"res://Game/Stage 1/Room 02.tscn",
		"res://Game/Stage 1/Room 03.tscn",
		"res://Game/Stage 1/Room 04.tscn",
		"res://Game/Stage 1/Room 05.tscn",
		"res://Game/Stage 1/Room 06.tscn",
		"res://Game/Stage 1/Room 07.tscn",
		"res://Game/Stage 1/Room 08.tscn",
		"res://Game/Stage 1/Room 09.tscn",
		"res://Game/Stage 1/Room 10.tscn",
		"res://Game/Stage 1/Room 11.tscn"
	]

# Function to instantiate a new room
func instantiate_new_room():
	# Check if there are available rooms
	if available_rooms.size() > 0:
		# Remove the last instantiated room, if any
		if instantiated_rooms.size() > 0:
			var last_instantiated_room = instantiated_rooms.pop_back()
			last_instantiated_room.queue_free()
			print("Removed Room: ", last_instantiated_room.get_name())

		# Choose a random index for the new room
		var random_index = randi() % available_rooms.size()
		
		# Get the path of the new room
		var new_room_path = available_rooms[random_index]
		
		# Remove the new room path from available rooms
		available_rooms.remove_at(random_index)
		
		# Load and instantiate the new room
		var new_room_instance = load(new_room_path).instantiate()
		
		# Add the instantiated room as a child of the current node (adjust as needed)
		add_child(new_room_instance)

		# Add the instantiated room instance to the list
		instantiated_rooms.append(new_room_instance)

		# Print the new room path
		print("Instantiated Room: ", new_room_path)
	else:
		print("No available rooms")

# Example of how to use the instantiate_new_room function
func _process(delta):
	# Check if the "ui_up" action is just pressed
	if Input.is_action_just_pressed("ui_up"):
		# Call instantiate_new_room when the condition is met
		instantiate_new_room()
