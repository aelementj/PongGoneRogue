class_name OptionsMenu2
extends Control

@onready var back_to_pause = $MarginContainer/VBoxContainer/BackToMain as Button

signal back_pause_menu

func _ready():
	back_to_pause.button_down.connect(_on_back_to_pause_pressed)
	set_process(false)

func _on_back_to_pause_pressed():
	back_pause_menu.emit()
	set_process(false)
	$HoverSFX.play()

func _on_back_to_pause_mouse_entered():
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





