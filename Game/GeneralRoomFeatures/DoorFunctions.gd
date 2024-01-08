extends Node2D

@onready var transition = $Transition


var closedDoor: Area2D
var openDoor: Area2D

var isDoorOpen: bool = false
var hasToggledDoor: bool = false  # New variable to track whether the door has been toggled

func _ready():
	closedDoor = $Closed
	openDoor = $Open
	openDoor.get_node("CollisionShape2D").disabled = true
	DoorGlobal.instance.addInitiatedDoor(self)
	DoorGlobal.instance.updateInitiatedDoorsCount(DoorGlobal.instance.initiatedDoorsCount + 1)
	

func _process(delta):
	# Check if initiated enemies count is zero and the door hasn't been toggled yet
	if EnemyGlobal.instance.initiatedEnemiesCount == 0 and not hasToggledDoor:
		$AnimatedSprite2D.play()
		toggleDoors()
		$Timer.start()

func toggleDoors():
	isDoorOpen = !isDoorOpen
	closedDoor.visible = !isDoorOpen
	openDoor.visible = isDoorOpen
	closedDoor.get_node("CollisionShape2D").disabled = isDoorOpen
	openDoor.get_node("CollisionShape2D").disabled = !isDoorOpen
	hasToggledDoor = true  # Mark that the door has been toggled
	Global.reset_ball_pos()

func _on_open_door_body_entered(body):
	if isDoorOpen and body.is_in_group("Ball"):
		onBallEnterOpenDoor()

func onBallEnterOpenDoor():
	transition.play("fade_out")


func disconnect_signals():
	openDoor.disconnect("body_entered", _on_open_door_body_entered)

func _exit_tree():
	disconnect_signals()
	DoorGlobal.instance.updateInitiatedDoorsCount(DoorGlobal.instance.initiatedDoorsCount - 1)

func _on_transition_animation_started(anim_name):
	print("Ball entered the open door!")
	emit_signal("ball_entered_open_door")
	DoorGlobal.instance.onBallEnterAnyOpenDoor()

func _on_timer_timeout():
	$Open2.play()

