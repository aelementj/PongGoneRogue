extends RigidBody2D

@export var speed = 30000

func _ready():
	# Set linear_damp to zero for less resistance
	linear_damp = 0.0

func _physics_process(delta):
	var movement = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		movement.x -= 1
	elif Input.is_action_pressed("ui_right"):
		movement.x += 1
		
	linear_velocity = movement.normalized() * speed * delta

	# Stop the object when no keys are pressed
	if movement == Vector2.ZERO:
		linear_velocity = Vector2.ZERO
