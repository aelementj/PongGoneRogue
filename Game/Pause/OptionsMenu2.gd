class_name OptionsMenu2
extends Control

@onready var back_to_pause = $MarginContainer/MarginContainer/VBoxContainer/BackToPause as Button

signal back_pause_menu

func _ready():
	back_to_pause.button_down.connect(_on_back_to_pause_pressed)
	set_process(false)

func _on_back_to_pause_pressed() -> void:
	back_pause_menu.emit()
	set_process(false)


