# TestNode.gd

extends Node

func _ready():
	# Create an instance of the global script
	var global_script_instance = preload("res://Game/Global Scripts/Global.gd").new()

	# Access global variables and call global functions
	print("Global variable from TestNode:", global_script_instance.global_variable)
	global_script_instance.global_function()
