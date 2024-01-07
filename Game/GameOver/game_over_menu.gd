extends Control

signal gameover_restart
signal gameover_back_to_main

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_restart_pressed():
	emit_signal("gameover_restart")



func _on_back_to_main_pressed():
	emit_signal("gameover_back_to_main")
