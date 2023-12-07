class_name OptionsMenu
extends Control

@onready var back_to_main = $MarginContainer/VBoxContainer/BackToMain as Button

signal back_main_menu

func _ready():
	back_to_main.button_down.connect(_on_back_to_main_pressed)
	set_process(false)

func _on_back_to_main_pressed() -> void:
	back_main_menu.emit()
	set_process(false)


