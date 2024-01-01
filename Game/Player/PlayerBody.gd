extends CharacterBody2D
class_name PlayerBody

var speed: float = 200.0
var teleport_distance: float = 100.0
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

	if is_teleport_position_valid(teleport_position):
		position = teleport_position

# Check if the teleport position is valid (not colliding with anything)
func is_teleport_position_valid(position: Vector2) -> bool:
	# Use move_and_collide without subtracting global_position
	var collision: KinematicCollision2D = move_and_collide(position)
	return collision == null

# Start cooldown timer
func start_teleport_cooldown():
	can_teleport = false
	$Timer.start(teleport_cooldown)

# Called when the timer completes (cooldown is over)
func _on_timer_timeout():
	can_teleport = true
