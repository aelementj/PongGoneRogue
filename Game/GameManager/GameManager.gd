extends Node

class_name GameManagerv1

@onready var transition = $Transition
var transistion_finished: bool = false

func _ready():
	transition.play("fade_in")
	PowerUpGlobal.reassignPowerUpToNullDoor()




signal toggle_game_paused(is_paused : bool)
var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

func _input(event : InputEvent):
	if(event.is_action_pressed("ui_cancel")):
		game_paused = !game_paused
		$Select.play()

func _process(delta):
	if not is_player_valid() and Global.player_lives == 0:
		game_paused = !game_paused
		$BGM.stop()
		$Select.play()
	if Global.player_reference == null and Global.player_lives > 0:
		Global.spawn_player()
		print("player spawned")
	
	if $BGM.playing == false:
		$BGM.play()
		print("replay")

func is_player_valid() -> bool:
	return Global.get_player_reference() != null


func _on_transition_animation_finished(anim_name):
	transistion_finished = true
	game_paused = false
	Global.player_show()
	Global.reset_ball_pos()


func _on_transition_animation_started(anim_name):
	transistion_finished = false
	game_paused = !game_paused
	Global.player_hide()
	Global.reset_ball_pos()
	
func next_level():
	queue_free()
	print("GM queue freed")
