extends Node

func reset_game_state():
	emit_signal("resetRooms")
	emit_signal("resetEnemies")

signal resetRooms
signal resetEnemies
