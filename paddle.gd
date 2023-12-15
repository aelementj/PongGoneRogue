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

func _on_Paddle_body_entered(body):
	# Check if the colliding body is the ball
	if body.is_in_group("ball"):
		# Check the relative motion of the ball and the paddle
		var relative_velocity = linear_velocity - body.linear_velocity
		var dot_product = relative_velocity.dot(linear_velocity.normalized())

		# If the dot product is negative, the ball is moving towards the paddle
		# Prevent the paddle from being carried along by the ball
		if dot_product < 0:
			linear_velocity = Vector2.ZERO

