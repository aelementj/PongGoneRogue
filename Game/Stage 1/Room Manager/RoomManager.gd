# RoomManager.gd
extends Node

# Array to store available room paths
var available_rooms : Array = []

# Array to store instantiated room instances
var instantiated_rooms : Array = []

var instantiation_in_progress : bool = false

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
		"res://Game/Stage 1/Room 11.tscn",
		"res://Game/Stage 1/Room 12.tscn"
	]
	
	# Shuffle the available rooms
	available_rooms.shuffle()
	
	DoorGlobal.instance.connect("ball_entered_any_open_door", _on_ball_entered_any_open_door)

func instantiate_new_room(room_path: String):
	if instantiation_in_progress:
		# Room instantiation is already in progress, skip
		return

	instantiation_in_progress = true

	if instantiated_rooms.size() > 0:
		var last_instantiated_room = instantiated_rooms.pop_back()
		last_instantiated_room.queue_free()
		print("Removed Room: ", last_instantiated_room.get_name())

	var room_00 = get_node("Room 0")  # Adjust this line based on the actual path of Room 00 in your scene
	if room_00:
		room_00.queue_free()

	var new_room_instance = load(room_path).instantiate()
	add_child(new_room_instance)
	instantiated_rooms.append(new_room_instance)
	print("Instantiated Room: ", room_path)
	
	print("Remaining Rooms:", available_rooms)

	# Allow the next instantiation after a short delay
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.connect("timeout", _on_instantiation_timer_timeout)
	add_child(timer)
	timer.name = "Timer"
	timer.start()

func _on_instantiation_timer_timeout():
	instantiation_in_progress = false
	var timer = get_node("Timer")
	if timer:
		timer.queue_free()

# Example of how to use the instantiate_new_room function
func _process(delta):
	# Check if the "ui_up" action is just pressed
	if Input.is_action_just_pressed("ui_up") and instantiation_in_progress == false:
		# Get the path of the next room from the shuffled array
		if available_rooms.size() > 0:
			var next_room_path = available_rooms.pop_back()
			instantiate_new_room(next_room_path)
		else:
			print("No available rooms")
	
func _on_ball_entered_any_open_door():
	# Implement the logic to get the path of the next room from the shuffled array
	if available_rooms.size() > 0 and instantiation_in_progress == false:
		var next_room_path = available_rooms.pop_back()
		instantiate_new_room(next_room_path)
	else:
		print("No available rooms")
