extends Control

signal demo_restart
signal demo_back_to_main

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_restart_pressed():
	emit_signal("demo_restart")



func _on_back_to_main_pressed():
	emit_signal("demo_back_to_main")
