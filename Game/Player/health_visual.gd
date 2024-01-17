extends Panel

# Variables
var heartScene = preload("res://Game/Player/PlayerHearts.tscn")
var ballScene = preload("res://Game/Player/PlayerBalls.tscn")
var manaScene = preload("res://Game/Player/PlayerMana.tscn")
var manaVisual: HBoxContainer
var heartVisual: HBoxContainer
var ballVisual: HBoxContainer
var currentHearts: int = 0
var currentBalls: int = 0
var currentMana: int = 0
var regen_mana_timer: Timer
var regen_mana_interval: float = 1.0  # Regenerate mana every 1 second

func _ready():
	heartVisual = $VBoxContainer/HealthVisualRow1
	ballVisual = $VBoxContainer/BallVisualRow3
	manaVisual = $VBoxContainer/ManaVisualRow2
	currentMana = Global.mana_count
	currentHearts = Global.get_player_lives()
	currentBalls = Global.ball_count
	updateHeartVisual()
	updateBallVisual()
	updateManaVisual()
	Global.connect("lives_decreased", removeHeart)
	Global.connect("lives_increased", addHeart)
	Global.connect("ball_increased", addBall)
	Global.connect("ball_decreased", removeBall)
	Global.connect("mana_increased", addMana)
	Global.connect("mana_decreased", removeMana)
	Global.connect("reduce_cd_mana", reduce_mana_regen)
	Global.connect("reset_cd_mana", reset_mana_regen)

	# Create and connect the mana regeneration timer
	regen_mana_timer = Timer.new()
	regen_mana_timer.wait_time = regen_mana_interval
	regen_mana_timer.one_shot = false
	regen_mana_timer.connect("timeout", _on_regen_mana_timer_timeout)
	add_child(regen_mana_timer)

	# Start the regeneration timer if mana is less than max
	if Global.mana_count < Global.max_mana_count:
		regen_mana_timer.start()

func _on_regen_mana_timer_timeout():
	if Global.mana_count < Global.max_mana_count:
		Global.increase_player_mana()
		print("Regenerating mana. Current mana: ", Global.mana_count)
	else:
		regen_mana_timer.stop()

func updateHeartVisual():
	# Remove existing hearts
	for child in heartVisual.get_children():
		child.queue_free()

	# Add hearts based on the current number
	for i in range(currentHearts):
		var heartInstance = heartScene.instantiate()
		heartVisual.add_child(heartInstance)

# Example of how to update the number of hearts
func addHeart():
	currentHearts += 1
	updateHeartVisual()

func removeHeart():
	currentHearts -= 1
	updateHeartVisual()

func updateBallVisual():
	# Remove existing hearts
	for child in ballVisual.get_children():
		child.queue_free()

	# Add hearts based on the current number
	for i in range(currentBalls):
		var ballInstance = ballScene.instantiate()
		ballVisual.add_child(ballInstance)

func addBall():
	currentBalls += 1
	updateBallVisual()

func removeBall():
	currentBalls -= 1
	updateBallVisual()

func updateManaVisual():
	# Remove existing hearts
	for child in manaVisual.get_children():
		child.queue_free()

	# Add hearts based on the current number
	for i in range(currentMana):
		var manaInstance = manaScene.instantiate()
		manaVisual.add_child(manaInstance)

# Example of how to update the number of hearts
func addMana():
	currentMana += 1
	updateManaVisual()

func removeMana():
	currentMana -= 1
	updateManaVisual()
	if Global.mana_count < Global.max_mana_count:
		regen_mana_timer.start()

func reduce_mana_regen():
	regen_mana_interval -= 0.1
	regen_mana_timer.wait_time = regen_mana_interval

func reset_mana_regen():
	regen_mana_interval = 1
	regen_mana_timer.wait_time = regen_mana_interval
	

func _process(delta):
	if Input.is_action_just_pressed("test10"):
		reduce_mana_regen()
