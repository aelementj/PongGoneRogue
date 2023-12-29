extends Control

@export var game_manager : GameManagerv1

@onready var panel = $Panel as Panel
@onready var mainmenu = load("res://mainmenu.tscn") as PackedScene

func _ready():
	hide()
	game_manager.connect("toggle_game_paused", _on_game_manager_toggle_game_paused)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_game_manager_toggle_game_paused(is_paused : bool):
	if(is_paused):
		show()
	else:
		hide()

func _on_resume_pressed():
	game_manager.game_paused = false


func _on_restart_pressed():
	_on_resume_pressed()
	Global.reset_balls()
	get_tree().reload_current_scene()


func _on_options_pressed():
	pass # Replace with function body.


func _on_back_to_main_pressed():
	_on_resume_pressed()
	get_tree().change_scene_to_packed(mainmenu)

