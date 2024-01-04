extends Node2D


func _ready():
	# Access the autoloaded singleton
	DoorGlobal.instance.connect("initiated_doors_count_changed", _on_initiated_doors_count_changed)

func _on_initiated_doors_count_changed(count):
	# Do something with the updated count
	print("Number of initiated doors: ", count)
