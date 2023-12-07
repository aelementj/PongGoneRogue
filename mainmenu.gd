class_name MainMenu
extends Control

@onready var Start = $MarginContainer/VBoxContainer/Start as Button
@onready var Options = $MarginContainer/VBoxContainer/Options as Button
@onready var Exit = $MarginContainer/VBoxContainer/Exit as Button

@onready var Game = load("res://Game.tscn") as PackedScene

func _ready():
	Start.button_down.connect(_on_start_pressed)
	Options.button_down.connect(_on_options_pressed)
	Exit.button_down.connect(_on_exit_pressed)
	
	


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(Game)


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
