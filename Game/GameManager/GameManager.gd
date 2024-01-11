extends Node

class_name GameManagerv1

@onready var transition = $Transition

func _ready():
	transition.play("fade_in")
	DoorGlobal.connect("demo2", thankyou_demo)
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
	if not is_player_valid():
		game_paused = !game_paused
		$Select.play()

func thankyou_demo():
	game_paused = !game_paused
	print("debuggm")
	$Select.play()


func is_player_valid() -> bool:
	return Global.get_player_reference() != null

func _on_transition_animation_finished(anim_name):
	pass

