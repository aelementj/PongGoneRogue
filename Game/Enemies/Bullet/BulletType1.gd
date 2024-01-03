extends CharacterBody2D

const SPEED = 300 

func _ready():
	velocity = Vector2(0, SPEED)  # Set initial velocity (upward, adjust as needed)

func _process(delta):
	move_and_slide()
