extends CharacterBody2D
class_name PlayerBody

var speed: float = 200.0
var teleport_distance: float = 50.0
var teleport_cooldown: float = 3.0
var can_teleport: bool = true

signal shoot_ball

func _ready():
	# Assuming the player is a child of the main scene root
	Global.set_player_reference(self)


func _process(delta):
	process_input()

# Process player input
func process_input():
	var direction: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	elif Input.is_action_pressed("ui_right"):
		direction.x += 1

	if can_teleport and Input.is_action_just_pressed("dash"):
		teleport(direction)
		start_teleport_cooldown()

	velocity = direction.normalized() * speed
	move_and_slide()

	if Input.is_action_pressed("ui_accept") and Global.has_ball():
		print(Global.ball_count)
		emit_signal("shoot_ball")
		Global.ball_count -= 1  # Decrement the ball count after shooting
		print(Global.ball_count)

# Teleport function
func teleport(direction: Vector2):
	var teleport_position: Vector2 = position + direction.normalized() * teleport_distance

	# Check if the destination position is valid
	if is_valid_teleport_position(teleport_position):
		position = teleport_position

# Check if the teleport position is valid (not colliding with obstacles)
func is_valid_teleport_position(teleport_position: Vector2) -> bool:
	var collision_info = move_and_collide(teleport_position - position)
	
	# Check if there is no collision (collision_info will be null if no collision occurred)
	return collision_info == null

# Start cooldown timer
func start_teleport_cooldown():
	can_teleport = false
	$Timer.start(teleport_cooldown)

# Called when the timer completes (cooldown is over)
func _on_timer_timeout():
	can_teleport = true

func is_moving() -> bool:
	var moving: bool = velocity.length() > 0.1
	return moving

# Function to handle being hit by a bullet
func _on_hit_by_bullet(body):
	if body.is_in_group("Bullet"):
		Global.decrease_player_lives()
		print("Player hit by a bullet. Remaining lives: ", Global.get_player_lives())
		body.queue_free()  # Remove the bullet from the scene
		
		if Global.get_player_lives() <= 0:
			trigger_player_defeated()

# Function to trigger player defeated event
func trigger_player_defeated():
	queue_free()
