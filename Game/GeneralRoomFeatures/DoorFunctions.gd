extends Node2D

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
		toggleDoors()

func toggleDoors():
	isDoorOpen = !isDoorOpen
	closedDoor.visible = !isDoorOpen
	openDoor.visible = isDoorOpen
	closedDoor.get_node("CollisionShape2D").disabled = isDoorOpen
	openDoor.get_node("CollisionShape2D").disabled = !isDoorOpen
	
	hasToggledDoor = true  # Mark that the door has been toggled

func _on_open_door_body_entered(body):
	if isDoorOpen and body.is_in_group("Ball"):
		onBallEnterOpenDoor()

func onBallEnterOpenDoor():
	print("Ball entered the open door!")
	emit_signal("ball_entered_open_door")
	DoorGlobal.instance.onBallEnterAnyOpenDoor()

func disconnect_signals():
	openDoor.disconnect("body_entered", _on_open_door_body_entered)

func _exit_tree():
	disconnect_signals()
	DoorGlobal.instance.updateInitiatedDoorsCount(DoorGlobal.instance.initiatedDoorsCount - 1)
