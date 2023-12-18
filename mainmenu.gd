class_name MainMenu
extends Control

@onready var Start = $MarginContainer/VBoxContainer/Start as Button
@onready var Options = $MarginContainer/VBoxContainer/Options as Button
@onready var Exit = $MarginContainer/VBoxContainer/Exit as Button
@onready var options_menu = $OptionsMenu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer
<<<<<<< Updated upstream
@onready var Game = load("res://Game.tscn") as PackedScene
=======
@onready var Game = preload("res://Experimental/experimental room.tscn") as PackedScene
>>>>>>> Stashed changes

func _ready():
	handle_connecting_signals()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(Game)


func _on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true


func _on_exit_pressed() -> void:
	get_tree().quit()

func main_menu_back() -> void:
	margin_container.visible = true
	options_menu.visible = false

func handle_connecting_signals() -> void:
	Start.button_down.connect(_on_start_pressed)
	Options.button_down.connect(_on_options_pressed)
	Exit.button_down.connect(_on_exit_pressed)
	options_menu.back_main_menu.connect(main_menu_back)
