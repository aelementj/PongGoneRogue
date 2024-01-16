extends Control

var progress = []
var sceneName
var scene_load_status = 0
var loadingComplete = false
var elapsedTime = 0
var delayDuration = 0.1  # Adjust this value to control the delay in seconds

func _ready():
	sceneName = "res://Game/GameManager/stage2_game_manager.tscn"
	ResourceLoader.load_threaded_request(sceneName)
	Global.player_hide()

func _process(delta):
	if loadingComplete:
		return

	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName, progress)
	$ProgressBar.value = floor(progress[0] * 100)
	#$Label.text = str(floor(progress[0] * 100)) + "%"

	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED and progress[0] >= 1.0:
		if elapsedTime >= delayDuration:
			var newScene = ResourceLoader.load_threaded_get(sceneName)
			get_tree().change_scene_to_packed(newScene)
			loadingComplete = true
		else:
			elapsedTime += delta

func _exit_tree():
	loadingComplete = false
	print("game loaded")
