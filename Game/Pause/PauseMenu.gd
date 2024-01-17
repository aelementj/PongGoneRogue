extends Control

@export var game_manager : GameManagerv1
@onready var options_menu = $OptionsMenu2 as OptionsMenu2
@onready var panel = $Panel as Panel
@onready var mainmenu = load("res://mainmenu.tscn") as PackedScene
@onready var gameover_menu = $GameOverMenu
@onready var thank_you_menu = $"Thank You Menu"
@onready var LoadingScreen = load("res://loading_screen.tscn") as PackedScene

func _ready():
	hide()
	game_manager.connect("toggle_game_paused", _on_game_manager_toggle_game_paused)
	gameover_menu.connect("gameover_restart", _on_restart_pressed)
	gameover_menu.connect("gameover_back_to_main", _on_back_to_main_pressed)
	handle_connecting_signals()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.player_lives == 0:
		show()
		panel.visible = false
		gameover_menu.set_process(true)
		gameover_menu.visible = true

func _on_game_manager_toggle_game_paused(is_paused : bool):
	if(is_paused) and game_manager.transistion_finished:
		show()
	else:
		hide()

func _on_resume_pressed():
	game_manager.game_paused = false
	$Select.play()

func _on_restart_pressed():
	_on_resume_pressed()
	Global.reset_balls()
	Global.reset_player_lives()
	Global.reset_player_mana()
	Global.remove_player()
	Global.reset_mana_cd()
	PowerUpGlobal.clearInitiatedDoors()
	get_tree().change_scene_to_packed(LoadingScreen)
	$Select.play()


func _on_options_pressed():
	panel.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
	$Select.play()

func _on_back_to_main_pressed():
	_on_resume_pressed()
	Global.reset_balls()
	Global.reset_player_lives()
	Global.remove_player()
	Global.reset_mana_cd()
	PowerUpGlobal.clearInitiatedDoors()
	get_tree().change_scene_to_packed(mainmenu)
	$Select.play()

func back_to_pause() -> void:
	panel.visible = true
	options_menu.visible = false

func handle_connecting_signals() -> void:
	options_menu.back_pause_menu.connect(back_to_pause)

func is_player_valid() -> bool:
	return Global.get_player_reference() != null
