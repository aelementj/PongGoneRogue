extends CharacterBody2D

var speed: float = 200.0
var last_input: int = 0  # 0 for no input, 1 for left, 2 for right
var teleport_timer: float = 0.0
var teleport_cooldown: float = 0.5  # Adjust this value to set the cooldown time

func _process(delta):
	process_input()
	teleport_timer -= delta

# Process player input
func process_input():
	var direction: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		last_input = 1
	elif Input.is_action_pressed("ui_right"):
		direction.x += 1
		last_input = 2
	else:
		last_input = 0

	velocity = direction.normalized() * speed

	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		if teleport_timer > 0 and last_input == 1:
			teleport(direction)
		elif teleport_timer > 0 and last_input == 2:
			teleport(direction)
		else:
			teleport_timer = teleport_cooldown

	move_and_slide()

# Teleport function
func teleport(direction: Vector2):
	var teleport_distance: float = 50.0
	var teleport_position: Vector2 = position + direction * teleport_distance

	position = teleport_position
	teleport_timer = 0
