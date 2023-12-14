
extends CharacterBody2D

var SPEED = 300

func _physics_process(delta):
	
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector.normalized()
	
	if input_vector:
		velocity = input_vector * SPEED
		move_and_slide()
		
	
