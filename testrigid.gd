extends RigidBody2D

var initial_speed = 500  # Adjust the initial speed as needed
var speed_increment = 50  # Adjust the speed increment as needed

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.is_in_group("walls"):
		# Calculate the new velocity to simulate bouncing off the wall
		var normal = body.transform.xform_inv(body.transform.basis_xform(Vector2.RIGHT)).normalized()
		linear_velocity = linear_velocity.bounce(normal)

		# Increase the speed slightly after each collision
		linear_velocity = linear_velocity.normalized() * (linear_velocity.length() + speed_increment)
