class_name MainMenu
extends Control

@onready var Start = $MarginContainer/VBoxContainer/Start as Button
@onready var Options = $MarginContainer/VBoxContainer/Options as Button
@onready var Exit = $MarginContainer/VBoxContainer/Exit as Button
@onready var options_menu = $OptionsMenu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer
@onready var Game = load("res://Experimental/experimental room.tscn") as PackedScene

func _ready():
	handle_connecting_signals()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(Game)
	$Select.play()


func _on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
	$Select.play()


func _on_exit_pressed() -> void:
	get_tree().quit()
	$Select.play()

func main_menu_back() -> void:
	margin_container.visible = true
	options_menu.visible = false
	$Select.play()

func handle_connecting_signals() -> void:
	Start.button_down.connect(_on_start_pressed)
	Options.button_down.connect(_on_options_pressed)
	Exit.button_down.connect(_on_exit_pressed)
	options_menu.back_main_menu.connect(main_menu_back)


func _on_start_mouse_entered():
	$HoverSFX.play()

func _on_options_mouse_entered():
	$HoverSFX.play()

func _on_exit_mouse_entered():
	$HoverSFX.play()
