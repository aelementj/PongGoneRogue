# EnemyGlobal.gd
extends Node

var instance
var initiatedEnemiesCount: int = 0
var initiatedEnemies: Array = []  # Array to store references to initiated enemies in the current scene

var initiatedSpawnersCount: int = 0
var initiatedSpawners: Array = []  # Array to store references to initiated spawners in the current scene

func _ready():
	# Set the singleton instance
	instance = self
	print("EnemyGlobal2 instance ready")

# Function to update the initiated enemies count
func updateInitiatedEnemiesCount(count):
	initiatedEnemiesCount = count
	emit_signal("initiated_enemies_count_changed", initiatedEnemiesCount)
	print("Initiated enemies count updated:", initiatedEnemiesCount)

# Function to add a reference to an initiated enemy
func addInitiatedEnemy(enemy):
	initiatedEnemies.append(enemy)
	print("Added reference to initiated enemy:", enemy)

# Function to get references to all initiated enemies in the current scene
func getInitiatedEnemies():
	return initiatedEnemies

# Function to update the initiated spawners count
func updateInitiatedSpawnersCount(count):
	initiatedSpawnersCount = count
	emit_signal("initiated_spawners_count_changed", initiatedSpawnersCount)
	print("Initiated spawners count updated:", initiatedSpawnersCount)

# Function to add a reference to an initiated spawner
func addInitiatedSpawner(spawner):
	initiatedSpawners.append(spawner)
	print("Added reference to initiated spawner:", spawner)

# Function to get references to all initiated spawners in the current scene
func getInitiatedSpawners():
	return initiatedSpawners
