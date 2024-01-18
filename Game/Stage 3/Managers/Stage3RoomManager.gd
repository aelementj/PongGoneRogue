# RoomManager.gd
extends Node

@onready var transition = $"../Transition"


# Array to store available room paths
var available_rooms : Array = []

var boss_room : Array = []

# Array to store instantiated room instances
var instantiated_rooms : Array = []

var instantiation_in_progress : bool = false

var room_count : int = 0

func _ready():
	# Initialize available room paths with your 12 room scenes
	available_rooms = [
		"res://Game/Stage 3/room1.3.tscn",
		"res://Game/Stage 3/room2.3.tscn",
		"res://Game/Stage 3/room3.3.tscn",
		"res://Game/Stage 3/room4.3.tscn",
		"res://Game/Stage 3/room5.3.tscn",
		"res://Game/Stage 3/room6.3.tscn",
		"res://Game/Stage 3/room7.3.tscn",
		"res://Game/Stage 3/room8.3.tscn",
		"res://Game/Stage 3/room9.3.tscn",
		"res://Game/Stage 3/room10.3.tscn",
		"res://Game/Stage 3/room11.3.tscn",
		"res://Game/Stage 3/room12.3.tscn"
	]
	
	boss_room = ["res://Game/Stage 3/boss_room3.tscn"]
	
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
	add_child.call_deferred(new_room_instance)
	instantiated_rooms.append(new_room_instance)
	print("Instantiated Room: ", room_path)
	
	print("Remaining Rooms:", available_rooms)

	# Allow the next instantiation after a short delay
	var timer = Timer.new()
	timer.wait_time = 1
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
func _on_ball_entered_any_open_door():
	transition.play("fade_in")
	# Check if there are available rooms and instantiation is not in progress
	if room_count < 6 and available_rooms.size() > 0 and instantiation_in_progress == false:
		var next_room_path = available_rooms.pop_back()
		instantiate_new_room(next_room_path)
		room_count += 1
		
		# Check if six regular rooms have been instantiated
	elif room_count == 6 and available_rooms.size() > 0 and instantiation_in_progress == false:
		# Initiate the boss room
		var boss_room_path = boss_room[0]
		instantiate_new_room(boss_room_path)
	else:
		print("No available rooms")
		

func _process(delta):
	if Input.is_action_just_pressed("clear"):
		_on_ball_entered_any_open_door()
