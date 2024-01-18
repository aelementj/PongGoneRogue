extends Node2D

@onready var transition = $Transition
@onready var PowerUpIcon: Sprite2D

var closedDoor: Area2D
var openDoor: Area2D


var isDoorOpen: bool = false
var hasToggledDoor: bool = false

var assignedPowerUp

func _ready():
	closedDoor = $Closed
	openDoor = $Open
	openDoor.get_node("CollisionShape2D").disabled = true
	DoorGlobal.instance.addInitiatedDoor(self)
	DoorGlobal.instance.updateInitiatedDoorsCount(DoorGlobal.instance.initiatedDoorsCount + 1)
	PowerUpIcon = $PowerUpIcon
	
	

func _process(delta):
	if EnemyGlobal.instance.initiatedEnemiesCount == 0 and not hasToggledDoor:
		$AnimatedSprite2D.play()
		toggleDoors()
		$Timer.start()
		if DoorGlobal.areAllInitiatedDoorsToggled():
			Global.reset_ball_pos()
			
			
	if Input.is_action_just_pressed("test2"):
		Global.reset_ball_pos()

func toggleDoors():
	isDoorOpen = !isDoorOpen
	closedDoor.visible = !isDoorOpen
	openDoor.visible = isDoorOpen
	closedDoor.get_node("CollisionShape2D").disabled = isDoorOpen
	openDoor.get_node("CollisionShape2D").disabled = !isDoorOpen
	hasToggledDoor = true
	print(DoorGlobal.areAllInitiatedDoorsToggled())
	updatePowerUpIcon()


func _on_open_door_body_entered(body):
	if isDoorOpen and body.is_in_group("Ball"):
		onBallEnterOpenDoor()

func onBallEnterOpenDoor():
	transition.play("fade_out")
	print("Player Acquired: ", assignedPowerUp)
	if assignedPowerUp in PowerUpGlobal.playerPowerUps:
		PowerUpGlobal.applyPowerUpToPlayer(Global.get_player_reference(), assignedPowerUp)
	elif assignedPowerUp in PowerUpGlobal.ballPowerUps:
		PowerUpGlobal.applyPowerUpToAllBalls(assignedPowerUp)

func updatePowerUpIcon():
	# Assuming each power-up has a corresponding texture
	match assignedPowerUp:
		"SpeedUp":
			PowerUpIcon.texture = preload("res://assets/Buttons by deo/PlayerSPD.png")
			PowerUpIcon.scale = Vector2(0.2, 0.15)
		"TeleportCooldown":
			PowerUpIcon.texture = preload("res://assets/Buttons by deo/Teleport CD.png")
			PowerUpIcon.scale = Vector2(0.2, 0.15)
		"TeleportDistance":
			PowerUpIcon.texture = preload("res://assets/Buttons by deo/Teleport.png")
			PowerUpIcon.scale = Vector2(0.2, 0.15)
		"AddLife":
			PowerUpIcon.texture = preload("res://assets/Buttons by deo/Add Health.png")
			PowerUpIcon.scale = Vector2(0.2, 0.15)
		"BallSpeed":
			PowerUpIcon.texture = preload("res://assets/Buttons by deo/Add BallSPD.png")
			PowerUpIcon.scale = Vector2(0.2, 0.15)
		"AddBall":
			PowerUpIcon.texture = preload("res://assets/Buttons by deo/AddBall.png")
			PowerUpIcon.scale = Vector2(0.2, 0.15)
		"AddMana":
			PowerUpIcon.texture = preload("res://assets/Buttons by deo/Add Mana.png")
			PowerUpIcon.scale = Vector2(0.2, 0.15)
		"ManaRegen":
			PowerUpIcon.texture = preload("res://assets/Buttons by deo/ManaCD.png")
			PowerUpIcon.scale = Vector2(0.2, 0.15)



func disconnect_signals():
	openDoor.disconnect("body_entered", _on_open_door_body_entered)
	DoorGlobal.instance.removeInitiatedDoor(self)

func _exit_tree():
	disconnect_signals()

func _on_transition_animation_started(anim_name):
	print("Ball entered the open door!")
	DoorGlobal.instance.onBallEnterAnyOpenDoor()
	PowerUpGlobal.hasAssignedPowerUp = false
	PowerUpGlobal.clearInitiatedDoors()


func _on_timer_timeout():
	$Open2.play()
