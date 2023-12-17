extends CanvasLayer

class_name UI

@onready var lifes_label = %HBoxContainer/LifesLabel
@onready var game_lost_container = $GameLostContainer

func set_lifes(lifes: int):
	lifes_label.text = "Lifes: %d" % lifes
	
func game_over():
	game_lost_container.show()
	
func _on_game_lost_button_2_pressed():
	get_tree().reload_current_scene()
	
func _on_game_lost_button_3_pressed():
	get_tree().change_scene_to_file("res://click_exit.tscn")


func _on_level_won_button_pressed():
	get_tree().change_scene_to_file("res://node.tscn")

func _on_level_won_button_2_pressed():
	get_tree().reload_current_scene()

func _on_level_won_button_3_pressed():
	get_tree().change_scene_to_file("res://click_exit.tscn")
