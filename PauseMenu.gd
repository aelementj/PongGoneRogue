extends Control

@export var game_manager : GameManager
@onready var options_menu = $OptionsMenu as OptionsMenu2
@onready var panel = $Panel as Panel
@onready var mainmenu = load("res://mainmenu.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	game_manager.connect("toggle_game_paused", _on_game_manager_toggle_game_paused)
	handle_connecting_signals()

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
	$Select.play()

func _on_restart_pressed():
	_on_resume_pressed()
	get_tree().reload_current_scene()
	$Select.play()


func _on_options_pressed():
	panel.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
	$Select.play()


func _on_back_to_main_pressed():
	_on_resume_pressed()
	get_tree().change_scene_to_packed(mainmenu)
	$Select.play()

func back_to_pause() -> void:
	panel.visible = true
	options_menu.visible = false
	$Select.play()

func handle_connecting_signals() -> void:
	options_menu.back_pause_menu.connect(back_to_pause)


func _on_resume_mouse_entered():
	$HoverSFX.play()


func _on_options_mouse_entered():
	$HoverSFX.play()


func _on_restart_mouse_entered():
	$HoverSFX.play()


func _on_back_to_main_mouse_entered():
	$HoverSFX.play()


