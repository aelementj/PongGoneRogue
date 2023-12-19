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
	$HoverSFX.play()

func _on_back_to_main_mouse_entered():
	$HoverSFX.play()


func _on_fullscreen_mouse_entered():
	$HoverSFX.play()


func _on_borderless_mouse_entered():
	$HoverSFX.play()


func _on_master_mouse_entered():
	$HoverSFX.play()


func _on_music_mouse_entered():
	$HoverSFX.play()


func _on_sound_fx_mouse_entered():
	$HoverSFX.play()


func _on_sound_fx_drag_ended(value_changed):
	$Select.play()


func _on_music_drag_ended(value_changed):
	$Select2.play()


func _on_master_drag_ended(value_changed):
	$Select3.play()
