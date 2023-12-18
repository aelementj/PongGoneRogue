extends Control

@export var experimental_room : GameScene
@onready var mainmenu = load("res://mainmenu.tscn") as PackedScene
@onready var margin_container = $Panel/MarginContainer as MarginContainer
@onready var options_menu = $Panel/OptionsMenu as OptionsMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	experimental_room.connect("toggle_game_paused", _on_experimental_room_toggle_game_paused)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_experimental_room_toggle_game_paused(is_paused : bool):
	if(is_paused):
		show()
	else:
		hide()
	
func _on_resume_pressed():
	experimental_room.game_paused = false

func _on_restart_pressed():
	_on_resume_pressed()
	get_tree().reload_current_scene()


func _on_main_menu_pressed():
	_on_resume_pressed()
	get_tree().change_scene_to_packed(mainmenu)
	
func _on_options_pressed() -> void:
	pass
	
func back_pause_menu() -> void:
	margin_container.visible = true
	options_menu.visible = false


