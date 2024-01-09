extends HSlider

@export
var bus_name : String

var bus_index : int

func _ready() -> void: 
	bus_index = AudioServer.get_bus_index(bus_name)
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)

@warning_ignore("shadowed_variable_base_class")
func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
	print(bus_name)

func _on_drag_ended(value_changed):
	$"../../../../../Select2Music".play()