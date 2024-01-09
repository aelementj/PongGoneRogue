extends Node

var playerPowerUps: Array = ["SpeedUp", "TeleportCooldown", "PowerUp3"]
var ballPowerUps: Array = ["BallBigger", "BallSpeed", "BallPowerUp3"]
var mixedPowerUps: Array = []  # Array to track assigned power-ups for both player and ball

var initiatedDoors: Array = []
var hasAssignedPowerUp: bool = false
var assignedPowerUps: Array = []  # Array to track assigned power-ups

func _ready():
	# Combine player and ball power-ups into the mixedPowerUps array
	mixedPowerUps = playerPowerUps + ballPowerUps

func _process(delta):
	initiatedDoors = DoorGlobal.initiatedDoors

	# Check if the player has cleared the new room and a power-up has not been assigned
	if EnemyGlobal.instance.initiatedEnemiesCount == 0 and not hasAssignedPowerUp:
		assignPowerUp()

func assignPowerUp():
	# Ensure there are initiated doors before assigning power-ups
	if initiatedDoors.size() > 0 and initiatedDoors.size() <= mixedPowerUps.size():
		# Iterate through initiated doors and assign a different power-up to each
		for door in initiatedDoors:
			var randomPowerUp: String

			while true:
				randomPowerUp = mixedPowerUps[randi() % mixedPowerUps.size()]
				if randomPowerUp not in assignedPowerUps:
					break

			print("Power-up assigned to ", door.get_name(), ": ", randomPowerUp)

			# Implement logic to apply the assigned power-up on the door
			# For example, you might have a function in the door script to handle this:
			door.assignedPowerUp = randomPowerUp

			assignedPowerUps.append(randomPowerUp)  # Track the assigned power-up

		hasAssignedPowerUp = true  # Mark that the power-up has been assigned
	else:
		print("Cannot assign power-ups. Not enough Power ups")
		hasAssignedPowerUp = true

func clearInitiatedDoors():
	initiatedDoors.clear()
	hasAssignedPowerUp = false  # Reset the flag when clearing initiated doors
	assignedPowerUps.clear()  # Clear the list of assigned power-ups

func applyPowerUpToPlayer(player: PlayerBody, powerUpType: String):
	match powerUpType:
		"SpeedUp":
			player.speed *= 1.5  # Increase player's speed by 50%
		"TeleportCooldown":
			player.teleport_cooldown /= 2  # Halve player's teleport cooldown
		# Add more cases for other player power-ups as needed

func applyPowerUpToBall(ball: BallBody, powerUpType: String):
	match powerUpType:
		"BallBigger":
			if ball.ball_size <= 2.0 and ball.size_multiplier <= 2:
				ball.ball_size += 0.1
				ball.size_multiplier += 0.1
			else:
				print("Max Size has been reached")
		"BallSpeed":
			ball.initial_ball_speed *= 1.1
