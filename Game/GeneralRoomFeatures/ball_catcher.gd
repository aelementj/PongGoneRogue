extends Node2D

# Connect the body_entered signal to this function in the editor
func _on_BallCatcher_body_entered(body):
	# Check if the entered body has a velocity variable
	if "velocity" in body:
		# Stop the object's velocity
		body.velocity = Vector2.ZERO
